//
//  SSV2HtmlView.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/13.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSV2HtmlView.h"
#import <DTFoundation/DTCoreGraphicsUtils.h>
#import <DTRichTextEditor/DTRichTextEditor.h>
#import <DTRichTextEditor/DTRichTextEditorView.h>
#import <DTRichTextEditor/DTCursorView.h>
#import <DTWebArchive/DTWebArchive.h>
#import <DTRichTextEditor/DTHTMLWriter+DTWebArchive.h>
#import <DTLoupe/DTLoupeView.h>
#import "SSV2HtmlView+Ranges.h"
#import "SSLayoutFrame+Selector.h"
#import "SSLayoutFrame+Cursor.h"
#import "SSV2HtmlView+Manipulation.h"
#import "SSLayoutLine.h"
#import "SSImageButton.h"

// the modes that can be dragged in
typedef enum
{
    DTDragModeNone = 0,
    DTDragModeLeftHandle,
    DTDragModeRightHandle,
    DTDragModeCursor,
    DTDragModeCursorInsideMarking
} DTDragMode;

@interface SSV2HtmlView ()<UIGestureRecognizerDelegate, UIPopoverControllerDelegate, SSHtmlViewDelegate>

@property (nonatomic, retain) DTTextSelectionView *selectionView;
@property (nonatomic, retain) DTCursorView *cursor;
@property (nonatomic, readwrite) UITextRange *markedTextRange;  // internal property writeable
@property (nonatomic, retain) NSDictionary *overrideInsertionAttributes;

@property (nonatomic, retain, readonly) NSArray *editorMenuItems;
@property (nonatomic, retain) UIPopoverController *definePopoverController; // used for presenting definitions of a selected term on the iPad

- (void)showContextMenuFromSelection;
- (void)hideContextMenu;

- (CGRect)visibleContentRect;
- (BOOL)selectionIsVisible;
- (void)relayoutText;

@end

@implementation SSV2HtmlView
{
    // private stuff
    id<UITextInputTokenizer> tokenizer;
    DTTextRange *_selectedTextRange;
    DTTextRange *_markedTextRange;
    NSDictionary *_markedTextStyle;
    
    UITextStorageDirection _selectionAffinity;
    
    // -- internal state
    DTDragMode _dragMode;
    BOOL _shouldReshowContextMenuAfterHide;
    BOOL _shouldShowContextMenuAfterLoupeHide;
    BOOL _shouldShowDragHandlesAfterLoupeHide;
    BOOL _shouldShowContextMenuAfterMovementEnded;
    BOOL _contextMenuVisible;
    
    CGPoint _dragCursorStartMidPoint;
    CGPoint _touchDownPoint;
    NSTimeInterval _lastCursorMovementTimestamp;
    CGPoint _lastCursorMovementTouchPoint;
    
    // UITextInputTraits
    UITextAutocapitalizationType autocapitalizationType; // default is UITextAutocapitalizationTypeSentences
    UITextAutocorrectionType autocorrectionType;         // default is UITextAutocorrectionTypeDefault
    
    // gesture recognizers
    UITapGestureRecognizer *_tapGesture;
    UITapGestureRecognizer *_doubleTapGesture;
    UITapGestureRecognizer *_tripleTapGesture;
    UILongPressGestureRecognizer *_longPressGesture;
    UIPanGestureRecognizer *_panGesture;
    
    
    // editor view delegate respondsTo cache flags
    struct {
        // Text and Selection Changes
        unsigned int delegateWillPasteTextInRange:1;
        unsigned int delegateDidChangeSelection:1;
        
        // Editing Menu Items
        unsigned int delegateMenuItems:1;
        unsigned int delegateCanPerformActionsWithSender:1;
    } _htmlViewDelegateFlags;
    
    // Use to disallow canPerformAction: to proceed up the responder chain (-nextResponder)
    BOOL _stopResponderChain;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self _setupDefaults];
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self _setupDefaults];
}

- (void)layoutSubviews
{
    // this also layouts the content View
    [super layoutSubviews];
    
    [_selectionView layoutSubviewsInRect:self.bounds];
    
    if (self.isDragging || self.decelerating)
    {
        DTLoupeView *loupe = [DTLoupeView sharedLoupe];
        
        if ([loupe isShowing] && loupe.style == DTLoupeStyleCircle)
        {
            loupe.seeThroughMode = YES;
        }
        
        if ([[UIMenuController sharedMenuController] isMenuVisible])
        {
            if (![_selectedTextRange isEmpty])
            {
                _shouldShowContextMenuAfterMovementEnded = YES;
            }
            
            [self hideContextMenu];
        }
        
        SEL selector = @selector(movementDidEnd);
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
        [self performSelector:selector withObject:nil afterDelay:0.5];
    }
}


- (void) _setupDefaults
{
    _canInteractWithPasteboard = YES;
    // -- text input
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.selectionAffinity = UITextStorageDirectionForward;
    
    // -- gestures
    if (!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGesture.delegate = self;
        _doubleTapGesture.numberOfTapsRequired = 2;
        _doubleTapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_doubleTapGesture];
    }
    
    if (!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        _tapGesture.delegate = self;
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [_tapGesture requireGestureRecognizerToFail:_doubleTapGesture];
        [self addGestureRecognizer:_tapGesture];
    }
    
    if (!_tripleTapGesture) {
        _tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap:)];
        _tripleTapGesture.delegate = self;
        _tripleTapGesture.numberOfTapsRequired = 3;
        _tripleTapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_tripleTapGesture];
    }
    
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        _longPressGesture.delegate = self;
        [self addGestureRecognizer:_longPressGesture];
    }
    
    if (!_panGesture)
    {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragHandle:)];
        _panGesture.delegate = self;
        [self addGestureRecognizer:_panGesture];
    }

    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
    [center addObserver:self selector:@selector(loupeDidHide:) name:DTLoupeDidHide object:nil];
    
    // style for displaying marked text
    self.markedTextStyle = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor], NSForegroundColorAttributeName, nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - gestures actions

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    // Bail out if not recognized
    if (gesture.state != UIGestureRecognizerStateRecognized)
    {
        return;
    }
    _cursor.state = DTCursorStateBlinking;
    
    // Update selection.  Text input system steals taps inside of marked text so if we receive a tap, we end multi-stage text input.
    [self.inputDelegate selectionWillChange:self];
    self.markedTextRange = nil;
    self.selectedTextRange = nil;
    [self.inputDelegate selectionDidChange:self];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture
{
    // Bail out if not recognized
    if (gesture.state != UIGestureRecognizerStateRecognized) {
        return;
    }
    
    // get the touch point now, because becoming first responder might change the position
    CGPoint touchPoint = [gesture locationInView:self.attributedContentView];
    
    // select a word closest to the touchPoint
    [self.inputDelegate selectionWillChange:self];
    
    UITextPosition *position = (id)[self closestPositionToPoint:touchPoint];
    UITextRange *wordRange = [self textRangeOfWordAtPosition:position];
    
    // Bail out if there isn't a word range or if we are editing and it's the same as the current word range
    if (wordRange == nil || [self.selectedTextRange isEqual:wordRange]) {
        return;
    }
    // Text input system steals taps inside of marked text so if we receive a tap, we end multi-stage text input.
    self.markedTextRange = nil;
    self.selectionView.dragHandlesVisible = YES;
    
    [self hideContextMenu];
    
    self.selectedTextRange = wordRange;
    
    [self showContextMenuFromSelection];
    
    [self.inputDelegate selectionDidChange:self];
}

- (void)handleTripleTap:(UITapGestureRecognizer *)gesture
{
    // Bail out if not recognized
    if (gesture.state != UIGestureRecognizerStateRecognized)
    {
        return;
    }
    
    // get the touch point now, because becoming first responder might change the position
    CGPoint touchPoint = [gesture locationInView:self.attributedContentView];
    
    // Select a paragraph containing the touchPoint
    UITextPosition *position = (id)[self closestPositionToPoint:touchPoint];
    UITextRange *textRange = [DTTextRange textRangeFromStart:position toEnd:position];
    textRange = [self textRangeOfParagraphsContainingRange:textRange];
    
    // Bail out if there isn't a paragraph range or if it's the same as the current selected range
    if (textRange == nil || [self.selectedTextRange isEqual:textRange])
        return;
    
    self.selectionView.dragHandlesVisible = YES;
    
    [self hideContextMenu];
    
    self.selectedTextRange = textRange;
    
    [self showContextMenuFromSelection];

}


- (void)handleLongPress:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.attributedContentView];
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
        {
            // If we get here during multi-stage input we need to cancel it because selectionChanged notifications won't update the text system appropriately.  Text system steals touches inside of marked text.
            if (self.markedTextRange)
            {
                [self.inputDelegate selectionWillChange:self];
                self.markedTextRange = nil;
                [self.inputDelegate selectionDidChange:self];
            }
            
            // wrap long press/drag handles in calls to the input delegate because the intermediate selection changes are not important to editing
            [self _inputDelegateSelectionDidChange];
            
            [self presentLoupeWithTouchPoint:touchPoint];
            _cursor.state = DTCursorStateStatic;
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            if (fabs(touchPoint.x - _lastCursorMovementTouchPoint.x) > 1.0)
                _lastCursorMovementTimestamp = [NSDate timeIntervalSinceReferenceDate];
            
            _lastCursorMovementTouchPoint = touchPoint;
            
            [self moveLoupeWithTouchPoint:touchPoint];
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            if (_dragMode != DTDragModeCursorInsideMarking)
            {
                NSTimeInterval delta = [NSDate timeIntervalSinceReferenceDate] - _lastCursorMovementTimestamp;
                
                if (delta < 0.25)
                {
                    if (_dragMode == DTDragModeLeftHandle)
                    {
                        [self extendSelectionToIncludeWordInDirection:UITextStorageDirectionBackward];
                    }
                    else if (_dragMode == DTDragModeRightHandle)
                    {
                        [self extendSelectionToIncludeWordInDirection:UITextStorageDirectionForward];
                    }
                }
            }
        }
            
        case UIGestureRecognizerStateCancelled:
        {
            _shouldShowContextMenuAfterLoupeHide = YES;
            _shouldShowDragHandlesAfterLoupeHide = YES;
            
            // If we were dragging around the circle loupe, notify delegate of the final cursor selectedTextRange
            if (_dragMode == DTDragModeCursor || _dragMode == DTDragModeCursorInsideMarking)
            {
                [self _editorViewDelegateDidChangeSelection];
            }
            
            // Dismissing will set _dragMode to DTDragModeNone
            [self dismissLoupeWithTouchPoint:touchPoint];
            
            // Notify that long press/drag handles has concluded and selection may be changed
            [self _inputDelegateSelectionDidChange];
            
            break;
        }
            
        case UIGestureRecognizerStateFailed:
        {
            break;
        }
    }
    
}


- (void)handleDragHandle:(UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.attributedContentView];
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStatePossible:
        {
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            // wrap long press/drag handles in calls to the input delegate because the intermediate selection changes are not important to editing
            [self _inputDelegateSelectionWillChange];
            
            
            [self presentLoupeWithTouchPoint:touchPoint];
            
            [self hideContextMenu];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            if (fabs(touchPoint.x - _lastCursorMovementTouchPoint.x) > 1.0)
                _lastCursorMovementTimestamp = [NSDate timeIntervalSinceReferenceDate];
            
            _lastCursorMovementTouchPoint = touchPoint;
            
            [self moveLoupeWithTouchPoint:touchPoint];
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            NSTimeInterval delta = [NSDate timeIntervalSinceReferenceDate] - _lastCursorMovementTimestamp;
            
            if (delta < 0.25)
            {
                if (_dragMode == DTDragModeLeftHandle)
                {
                    [self extendSelectionToIncludeWordInDirection:UITextStorageDirectionBackward];
                }
                else if (_dragMode == DTDragModeRightHandle)
                {
                    [self extendSelectionToIncludeWordInDirection:UITextStorageDirectionForward];
                }
            }
        }
            
        case UIGestureRecognizerStateCancelled:
        {
            _shouldShowContextMenuAfterLoupeHide = YES;
            _shouldShowDragHandlesAfterLoupeHide = YES;
            
            [self dismissLoupeWithTouchPoint:touchPoint];
            
            // Notify that long press/drag handles has concluded and selection may be changed
            [self _inputDelegateSelectionDidChange];
            
            break;
        }
            
        case UIGestureRecognizerStateFailed:
        {
            break;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    
    // ignore touches on views that UITextInput adds
    // those are added to self, user custom views are subviews of contentView
    UIView *hitView = [self hitTest:touchPoint withEvent:nil];
    
    if (hitView.superview == self && hitView != self.attributedContentView)
    {
        return NO;
    }
    
    if (gestureRecognizer == _panGesture)
    {
        if (![_selectionView dragHandlesVisible])
        {
            return NO;
        }
        
        if (CGRectContainsPoint(_selectionView.dragHandleLeft.frame, touchPoint))
        {
            _dragMode = DTDragModeLeftHandle;
        }
        else if (CGRectContainsPoint(_selectionView.dragHandleRight.frame, touchPoint))
        {
            _dragMode = DTDragModeRightHandle;
        }
        
        
        if (_dragMode == DTDragModeLeftHandle || _dragMode == DTDragModeRightHandle)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    
    if (!self.isFirstResponder)
        return NO;
    
    [self setMenuItems];
    
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    
    if (!self.isFirstResponder)
    {
        // Remove custom menu items
        [[UIMenuController sharedMenuController] setMenuItems:nil];
    }
    return !self.isFirstResponder;
}

- (UIResponder *)nextResponder
{
    if (_stopResponderChain)
    {
        _stopResponderChain = NO;
        return nil;
    }
    
    return [super nextResponder];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    // If the delegate provides custom menu items, check to see if this selector is one of the menu items
    if (_htmlViewDelegateFlags.delegateMenuItems)
    {
        // Check delegate's custom menu items and return the delegate as the forwarding target if action matches
        for (UIMenuItem *menuItem in self.htmlViewDelegate.menuItems)
        {
            if (menuItem.action == aSelector)
                return self.htmlViewDelegate;
        }
    }
    
    return nil;
}


#pragma mark - Context Menu
#pragma mark - 
#pragma mark - Menu View

- (NSArray *)editorMenuItems
{
    if (_editorMenuItems == nil)
    {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        if ([UIReferenceLibraryViewController class])
        {
            UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(mCopy:)];
            UIMenuItem *selectAllItem = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(mSelectAll:)];
            UIMenuItem *selectItem = [[UIMenuItem alloc] initWithTitle:@"选择" action:@selector(mSelect:)];
            [items addObject:copyItem];
            [items addObject:selectAllItem];
            [items addObject:selectItem];
        }
        
        _editorMenuItems = items;
    }
    
    return _editorMenuItems;
}

- (void)hideContextMenu
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if ([menuController isMenuVisible])
    {
        [menuController setMenuVisible:NO animated:YES];
    }
    
    _contextMenuVisible = NO;
}

#pragma mark - 待解决问题的方法
#pragma mark - 导致键盘弹起的问题
- (void)showContextMenuFromSelection
{
    // Attempt to become first responder if needed for context menu
    if (!self.attributedContentView.isFirstResponder)
    {
        [self.attributedContentView becomeFirstResponder];
        
        if (!self.attributedContentView.isFirstResponder)
            return;
    }
    
    // Bail out if selection isn't visible
    if (![self selectionIsVisible])
    {
        // don't show it
        return;
    }
    
    [self setMenuItems];
    
    // Display the context menu
    _contextMenuVisible = YES;
    CGRect targetRect = [self visibleBoundsOfCurrentSelection];
    
    // Present the menu
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setTargetRect:targetRect inView:self.attributedContentView];
    [menuController setMenuVisible:YES animated:YES];
}

- (void) setMenuItems
{
    [[UIMenuController sharedMenuController] setMenuItems:self.editorMenuItems];
}


- (void)menuDidHide:(NSNotification *)notification
{
    if (_shouldReshowContextMenuAfterHide)
    {
        _shouldReshowContextMenuAfterHide = NO;
        
        [self performSelector:@selector(showContextMenuFromSelection) withObject:nil afterDelay:0.10];
    }
}

- (void)loupeDidHide:(NSNotification *)notification
{
    if (_shouldShowContextMenuAfterLoupeHide)
    {
        _shouldShowContextMenuAfterLoupeHide = NO;
        
        [self performSelector:@selector(showContextMenuFromSelection) withObject:nil afterDelay:0.10];
    }
    
    if (_shouldShowDragHandlesAfterLoupeHide)
    {
        _shouldShowDragHandlesAfterLoupeHide = NO;
        
        _selectionView.dragHandlesVisible = YES;
    }
}

- (void)movementDidEnd
{
    if (_shouldShowContextMenuAfterMovementEnded || _contextMenuVisible)
    {
        _shouldShowContextMenuAfterMovementEnded = NO;
        [self showContextMenuFromSelection];
    }
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // Delegate gets the first say, can disable any action
    if (_htmlViewDelegateFlags.delegateCanPerformActionsWithSender)
    {
        if (![self.htmlViewDelegate htmlView:self canPerformAction:action withSender:sender])
        {
            _stopResponderChain = YES;
            return NO;
        }
        
        if (_htmlViewDelegateFlags.delegateMenuItems)
        {
            // Check delegate's custom menu items and return YES if action matches
            for (UIMenuItem *menuItem in self.htmlViewDelegate.menuItems)
            {
                if (menuItem.action == action && ![self respondsToSelector:menuItem.action])
                    return YES;
            }
        }
    }
    
    
    if (action == @selector(mSelectAll:))
    {
        if (([[_selectedTextRange start] isEqual:(id)[self beginningOfDocument]] && [[_selectedTextRange end] isEqual:(id)[self endOfDocument]]))
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    if (action == @selector(mSelect:))
    {
        // selection only possibly from cursor, not when already selection in place
        if ([_selectedTextRange length])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    // stuff below needs a selection
    if (!_selectedTextRange)
    {
        return NO;
    }
    
    if (!_canInteractWithPasteboard)
    {
        return NO;
    }
    
    // stuff below needs a selection with multiple chars
    if ([_selectedTextRange isEmpty])
    {
        return NO;
    }
    
    if (action == @selector(mCopy:))
    {
        return YES;
    }
    
    if (action == @selector(mDefine:))
    {
        if( ![UIReferenceLibraryViewController class] )
            return NO;
        
        NSString *selectedTerm = [self textInRange:self.selectedTextRange];
        return [UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:selectedTerm];
    }
    
    
    return NO;
}

#pragma mark - Menu Action
- (void)mCopy:(id)sender
{
    if ([_selectedTextRange isEmpty])
    {
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSRange selectedRange = [_selectedTextRange NSRangeValue];
    
    if ([_selectedTextRange.end isEqual:[self endOfDocument]])
    {
        // we also want the ending paragraph mark
        selectedRange.length ++;
    }
    
    NSAttributedString *attributedString = [self.attributedContentView.layoutFrame.attributedStringFragment attributedSubstringFromRange:selectedRange];
    
    // plain text omits attachments and format
    NSString *plainText = [attributedString plainTextString];
    
    // all HTML generation goes via a writer
    DTHTMLWriter *writer = [[DTHTMLWriter alloc] initWithAttributedString:attributedString];
    
    // create a web archive
    DTWebArchive *webArchive = [writer webArchive];
    NSData *data = [webArchive data];
    
    // set multiple formats at the same time
    NSArray *items = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:data, WebArchivePboardType, plainText, @"public.utf8-plain-text", nil], nil];
    [pasteboard setItems:items];
}

- (void)mSelect:(id)sender
{
    UITextPosition *currentPosition = (DTTextPosition *)[_selectedTextRange start];
    UITextRange *wordRange = [self textRangeOfWordAtPosition:currentPosition];
    
    if (wordRange)
    {
        _shouldReshowContextMenuAfterHide = YES;
        self.selectionView.dragHandlesVisible = YES;
        
        self.selectedTextRange = wordRange;
    }
}

- (void)mSelectAll:(id)sender
{
    _shouldReshowContextMenuAfterHide = YES;
    self.selectionView.dragHandlesVisible = YES;
    
    self.selectedTextRange = [DTTextRange textRangeFromStart:self.beginningOfDocument toEnd:self.endOfDocument];
}

- (void)mDefine:(id)sender
{
    if (![UIReferenceLibraryViewController class])
        return;
    
    if (!self.selectedTextRange || [self.selectedTextRange isEmpty])
        return;
    
    NSString *selectedTerm = [self textInRange:self.selectedTextRange];
    
    if (![UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:selectedTerm])
        return;
    
    UIReferenceLibraryViewController *dictionaryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:selectedTerm];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIApplication *application = [UIApplication sharedApplication];
        UIWindow *window = [application keyWindow];
        [window.rootViewController presentViewController:dictionaryViewController animated:YES completion:nil];
    }
    else // iPad
    {
        CGRect targetRect = [self visibleBoundsOfCurrentSelection];
        
        if (CGRectIsNull(targetRect))
            return;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:dictionaryViewController];
        popover.delegate = self;
        [popover presentPopoverFromRect:targetRect
                                 inView:self
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
        
        self.definePopoverController = popover;
    }
}


#pragma mark Geometry and Hit-Testing Methods
- (CGRect)firstRectForRange:(DTTextRange *)range
{
    return [self.attributedContentView.layoutFrame firstRectForRange:[range NSRangeValue]];
}

- (CGRect)caretRectForPosition:(DTTextPosition *)position
{
    NSInteger index = position.location;
    
    SSLayoutLine *layoutLine = [self.attributedContentView.layoutFrame lineContainingIndex:index];
    
    CGRect caretRect = [self.attributedContentView.layoutFrame cursorRectAtIndex:index];
    
    caretRect.size.height = roundf(layoutLine.frame.size.height);
    caretRect.origin.x = roundf(caretRect.origin.x);
    caretRect.origin.y = roundf(layoutLine.frame.origin.y);
    
    return caretRect;
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    return [self.attributedContentView.layoutFrame  selectionRectsForRange:[(DTTextRange *)range NSRangeValue]];
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    NSInteger newIndex = [self.attributedContentView.layoutFrame closestCursorIndexToPoint:point];
    
    // move cursor out of a list prefix, we don't want those
    NSAttributedString *attributedString = self.attributedString;
    
    NSRange listPrefixRange = [attributedString rangeOfFieldAtIndex:newIndex];
    
    if (listPrefixRange.location != NSNotFound)
    {
        newIndex = NSMaxRange(listPrefixRange);
    }
    
    return [DTTextPosition textPositionWithLocation:newIndex];
}

// called when marked text is showing
- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(DTTextRange *)range
{
    DTTextPosition *position = (id)[self closestPositionToPoint:point];
    
    if (range)
    {
        if ([position compare:[range start]] == NSOrderedAscending)
        {
            return [range start];
        }
        
        if ([position compare:[range end]] == NSOrderedDescending)
        {
            return [range end];
        }
    }
    
    return position;
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
    NSInteger index = [self.attributedContentView.layoutFrame closestCursorIndexToPoint:point];
    
    DTTextPosition *position = [DTTextPosition textPositionWithLocation:index];
    DTTextRange *range = [DTTextRange textRangeFromStart:position toEnd:position];
    
    return range;
}


#pragma mark Text Input Delegate and Text Input Tokenizer
@synthesize inputDelegate;
- (id<UITextInputTokenizer>) tokenizer
{
    if (!tokenizer)
    {
        tokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
    }
    return tokenizer;
}


#pragma mark - selection/Marking/Cursor
- (CGRect)boundsOfCurrentSelection
{
    CGRect targetRect = CGRectZero;
    
    if ([_selectedTextRange length])
    {
        targetRect = [_selectionView selectionEnvelope];
    }
    else
    {
        targetRect = self.cursor.frame;
    }
    
    return targetRect;
}

- (CGRect)visibleBoundsOfCurrentSelection
{
    CGRect targetRect = [self boundsOfCurrentSelection];
    
    CGRect visibleRect;
    visibleRect.origin = self.contentOffset;
    visibleRect.size = self.bounds.size;
    targetRect = CGRectIntersection(targetRect, visibleRect);
    
    return targetRect;
}

- (void)_scrollRectInContentViewToVisible:(CGRect)rect animated:(BOOL)animated
{
    UIEdgeInsets reverseInsets = self.attributedContentView.edgeInsets;
    reverseInsets.top *= -1.0;
    reverseInsets.bottom *= -1.0;
    reverseInsets.left *= -1.0;
    reverseInsets.right *= -1.0;
    
    CGRect scrollToRect = UIEdgeInsetsInsetRect(rect, reverseInsets);
    
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        
        // this prevents multiple scrolling to same position
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    // make sure that the target scroll rect is inside the content view
    scrollToRect = CGRectIntersection(scrollToRect, self.attributedContentView.bounds);
    
    [self scrollRectToVisible:scrollToRect animated:NO];
    
    if (animated)
    {
        [UIView commitAnimations];
    }
}
- (void)scrollCursorVisibleAnimated:(BOOL)animated
{

    CGRect cursorFrame = [self caretRectForPosition:self.selectedTextRange.start];
    cursorFrame.size.width = 3.0;
    
    [self _scrollRectInContentViewToVisible:cursorFrame animated:animated];
}

- (void)updateCursorAnimated:(BOOL)animated
{
    // no selection
    if (self.selectedTextRange == nil)
    {
        // remove cursor
        [_cursor removeFromSuperview];
        
        // remove selection
        _selectionView.selectionRectangles = nil;
        _selectionView.dragHandlesVisible = NO;
        
        return;
    }
    
    // single cursor
    if ([_selectedTextRange isEmpty])
    {
        // show as a single caret
        _selectionView.dragHandlesVisible = NO;
        
        DTTextPosition *position = (id)self.selectedTextRange.start;
        CGRect cursorFrame = [self caretRectForPosition:position];
        cursorFrame.size.width = 3.0;
        
        if (!CGRectEqualToRect(cursorFrame, self.cursor.frame))
        {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.cursor.frame = cursorFrame;
            [CATransaction commit];
        }
        
        if (!_cursor.superview)
        {
            [self addSubview:_cursor];
        }
        
        [self scrollCursorVisibleAnimated:YES];
    }
    else
    {
        // show as a blue selection range
        self.selectionView.style = DTTextSelectionStyleSelection;
        self.selectionView.dragHandlesVisible = YES;
        NSArray *textSelectionRects = [self selectionRectsForRange:_selectedTextRange];
        [_selectionView setSelectionRectangles:textSelectionRects animated:animated];
        
        // no cursor
        [_cursor removeFromSuperview];
        
        if ([textSelectionRects count])
        {
            // scroll the currently dragged handle to be visible
            
            if (_dragMode == DTDragModeLeftHandle)
            {
                DTTextSelectionRect *selectionRect = [textSelectionRects objectAtIndex:0];
                [self _scrollRectInContentViewToVisible:selectionRect.rect animated:YES];
            }
            else if (_dragMode == DTDragModeRightHandle)
            {
                DTTextSelectionRect *selectionRect = [textSelectionRects lastObject];
                [self _scrollRectInContentViewToVisible:selectionRect.rect animated:YES];
            }
        }
        
        return;
    }
    
    if (_markedTextRange)
    {
        self.selectionView.style = DTTextSelectionStyleMarking;
        
        NSArray *textSelectionRects = [self selectionRectsForRange:_markedTextRange];
        _selectionView.selectionRectangles = textSelectionRects;
        
        _selectionView.dragHandlesVisible = NO;
    }
    else
    {
        _selectionView.selectionRectangles = nil;
    }
}

// in edit mode or if not firstResponder we select words
- (void)selectWordAtPositionClosestToLocation:(CGPoint)location
{
    UITextPosition *position = (id)[self closestPositionToPoint:location];
    UITextRange *wordRange = [self textRangeOfWordAtPosition:position];
    self.selectedTextRange = wordRange;
}


- (BOOL)moveCursorToPositionClosestToLocation:(CGPoint)location
{
    BOOL didMove = NO;
    
    DTTextRange *constrainingRange = nil;
    
    if ([_markedTextRange length] && [self selectionIsVisible])
    {
        constrainingRange = _markedTextRange;
    }
    else if ([_selectedTextRange length] && [self selectionIsVisible])
    {
        constrainingRange =_selectedTextRange;
    }
    
    DTTextPosition *position = (id)[self closestPositionToPoint:location withinRange:constrainingRange];
    
    // Move if there is a selection or if the position is not the same as the cursor
    if (![_selectedTextRange isEmpty] || ![(DTTextPosition *)_selectedTextRange.start isEqual:position])
    {
        didMove = YES;
        
        self.selectedTextRange = [self textRangeFromPosition:position toPosition:position];
    }
    
    return didMove;
}


- (void)presentLoupeWithTouchPoint:(CGPoint)touchPoint
{
    _touchDownPoint = touchPoint;
    
    DTLoupeView *loupe = [DTLoupeView sharedLoupe];
    loupe.targetView = self.attributedContentView;
    
    if (_selectionView.dragHandlesVisible)
    {
        if (CGRectContainsPoint(_selectionView.dragHandleLeft.frame, touchPoint))
        {
            _dragMode = DTDragModeLeftHandle;
        }
        else if (CGRectContainsPoint(_selectionView.dragHandleRight.frame, touchPoint))
        {
            _dragMode = DTDragModeRightHandle;
        }
        else
        {
            _dragMode = DTDragModeCursor;
        }
    }
    else
    {
        if (_markedTextRange)
        {
            _dragMode = DTDragModeCursorInsideMarking;
        }
        else
        {
            _dragMode = DTDragModeCursor;
        }
    }
    
    if (_dragMode == DTDragModeLeftHandle)
    {
        CGPoint loupeStartPoint;
        CGRect rect = [_selectionView beginCaretRect];
        
        // avoid presenting if there is no selection
        if (CGRectIsNull(rect))
        {
            return;
        }
        
        loupeStartPoint = CGPointMake(CGRectGetMidX(rect), rect.origin.y);
        
        _dragCursorStartMidPoint = DTCGRectCenter(rect);
        
        loupe.style = DTLoupeStyleRectangleWithArrow;
        loupe.magnification = 0.5;
        loupe.touchPoint = loupeStartPoint;
        [loupe presentLoupeFromLocation:loupeStartPoint];
        
        return;
    }
    
    if (_dragMode == DTDragModeRightHandle)
    {
        CGPoint loupeStartPoint;
        
        CGRect rect = [_selectionView endCaretRect];
        
        // avoid presenting if there is no selection
        if (CGRectIsNull(rect))
        {
            return;
        }
        
        loupeStartPoint = DTCGRectCenter(rect);
        _dragCursorStartMidPoint = DTCGRectCenter(rect);
        
        
        loupe.style = DTLoupeStyleRectangleWithArrow;
        loupe.magnification = 0.5;
        loupe.touchPoint = loupeStartPoint;
        loupe.touchPointOffset = CGSizeMake(0, rect.origin.y - _dragCursorStartMidPoint.y);
        [loupe presentLoupeFromLocation:loupeStartPoint];
        
        return;
    }
    
    if (_dragMode == DTDragModeCursorInsideMarking)
    {
        loupe.style = DTLoupeStyleRectangleWithArrow;
        loupe.magnification = 0.5;
        
        CGPoint loupeStartPoint = DTCGRectCenter(_cursor.frame);
        
        loupe.touchPoint = loupeStartPoint;
        [loupe presentLoupeFromLocation:loupeStartPoint];
        
        return;
    }
    
    // normal round loupe
    loupe.style = DTLoupeStyleCircle;
    loupe.magnification = 1.2;
    
    [self selectWordAtPositionClosestToLocation:touchPoint];
    _selectionView.dragHandlesVisible = NO;
    
    loupe.touchPoint = touchPoint;
    [loupe presentLoupeFromLocation:touchPoint];
}

- (void)moveLoupeWithTouchPoint:(CGPoint)touchPoint
{
    DTLoupeView *loupe = [DTLoupeView sharedLoupe];
    
    if (_dragMode == DTDragModeCursor)
    {
        CGRect visibleArea = [self visibleContentRect];
        
        // switch to see-through mode outside of visible content area
        if (CGRectContainsPoint(visibleArea, touchPoint))
        {
            loupe.seeThroughMode = NO;
            loupe.touchPoint = touchPoint;
        }
        else
        {
            loupe.seeThroughMode = YES;
            
            // restrict bottom of loupe frame to visible area
            CGPoint restrictedTouchPoint = touchPoint;
            restrictedTouchPoint.y = MIN(touchPoint.y, CGRectGetMaxY(visibleArea)+3);
            
            loupe.touchPoint = restrictedTouchPoint;
        }
        
        [self hideContextMenu];
        
        [self selectWordAtPositionClosestToLocation:touchPoint];
        _selectionView.dragHandlesVisible = NO;
        
        return;
    }
    
    if (_dragMode == DTDragModeCursorInsideMarking)
    {
        [self moveCursorToPositionClosestToLocation:touchPoint];
        
        loupe.touchPoint = DTCGRectCenter(_cursor.frame);
        loupe.seeThroughMode = NO;
        
        [self hideContextMenu];
        
        return;
    }
    
    CGPoint translation = touchPoint;
    translation.x -= _touchDownPoint.x;
    translation.y -= _touchDownPoint.y;
    
    // get current mid point
    CGPoint movedMidPoint = _dragCursorStartMidPoint;
    movedMidPoint.x += translation.x;
    movedMidPoint.y += translation.y;
    
    DTTextPosition *position = (DTTextPosition *)[self closestPositionToPoint:movedMidPoint];
    
    DTTextPosition *startPosition = (DTTextPosition *)_selectedTextRange.start;
    DTTextPosition *endPosition = (DTTextPosition *)_selectedTextRange.end;
    
    DTTextRange *newRange = nil;
    
    if (_dragMode == DTDragModeLeftHandle)
    {
        if ([position compare:endPosition]==NSOrderedAscending)
        {
            newRange = [DTTextRange textRangeFromStart:position toEnd:endPosition];
        }
    }
    else if (_dragMode == DTDragModeRightHandle)
    {
        if ([startPosition compare:position]==NSOrderedAscending)
        {
            newRange = [DTTextRange textRangeFromStart:startPosition toEnd:position];
        }
    }
    
    if (newRange && ![newRange isEqual:_selectedTextRange])
    {
        self.selectedTextRange = newRange;
    }
    
    if (_dragMode == DTDragModeLeftHandle)
    {
        CGRect rect = [_selectionView beginCaretRect];
        
        CGFloat zoom =  25.0f / rect.size.height;
        [DTLoupeView sharedLoupe].magnification = zoom;
        
        CGPoint point = CGPointMake(CGRectGetMidX(rect), rect.origin.y);
        loupe.touchPoint = point;
    }
    else if (_dragMode == DTDragModeRightHandle)
    {
        CGRect rect = [_selectionView endCaretRect];
        CGFloat zoom = 25.0f / rect.size.height;
        [DTLoupeView sharedLoupe].magnification = zoom;
        
        CGPoint point = DTCGRectCenter(rect);
        loupe.touchPoint = point;
    }
}

- (void)dismissLoupeWithTouchPoint:(CGPoint)touchPoint
{
    DTLoupeView *loupe = [DTLoupeView sharedLoupe];
    
    if (_dragMode == DTDragModeCursor || _dragMode == DTDragModeCursorInsideMarking)
    {
        CGRect rect = [_selectionView beginCaretRect];
        CGPoint point = CGPointMake(CGRectGetMidX(rect), rect.origin.y);
        [loupe dismissLoupeTowardsLocation:point];
    }
    else if (_dragMode == DTDragModeLeftHandle)
    {
        CGRect rect = [_selectionView beginCaretRect];
        CGPoint point = DTCGRectCenter(rect);
        _shouldShowContextMenuAfterLoupeHide = YES;
        [loupe dismissLoupeTowardsLocation:point];
    }
    else if (_dragMode == DTDragModeRightHandle)
    {
        _shouldShowContextMenuAfterLoupeHide = YES;
        CGRect rect = [_selectionView endCaretRect];
        CGPoint point = DTCGRectCenter(rect);
        [loupe dismissLoupeTowardsLocation:point];
    }
    
    _dragMode = DTDragModeNone;
}

- (void)extendSelectionToIncludeWordInDirection:(UITextStorageDirection)direction
{
    if (direction == UITextStorageDirectionForward)
    {
        if ([[self tokenizer] isPosition:_selectedTextRange.end atBoundary:UITextGranularityWord inDirection:UITextStorageDirectionForward])
        {
            // already at end of word
            return;
        }
        
        
        UITextPosition *newEnd = (id)[[self tokenizer] positionFromPosition:_selectedTextRange.end
                                                                 toBoundary:UITextGranularityWord
                                                                inDirection:UITextStorageDirectionForward];
        
        if (!newEnd)
        {
            // no word boundary after position
            return;
        }
        
        DTTextRange *newRange = [DTTextRange textRangeFromStart:_selectedTextRange.start toEnd:newEnd];
        
        [self setSelectedTextRange:newRange animated:YES];
    }
    else if (direction == UITextStorageDirectionBackward)
    {
        if ([[self tokenizer] isPosition:_selectedTextRange.start atBoundary:UITextGranularityWord inDirection:UITextStorageDirectionBackward])
        {
            // already at end of word
            return;
        }
        
        
        UITextPosition *newStart = (id)[[self tokenizer] positionFromPosition:_selectedTextRange.start
                                                                   toBoundary:UITextGranularityWord
                                                                  inDirection:UITextStorageDirectionBackward];
        
        if (!newStart)
        {
            // no word boundary before position
            return;
        }
        
        DTTextRange *newRange = [DTTextRange textRangeFromStart:newStart toEnd:_selectedTextRange.end];
        
        [self setSelectedTextRange:newRange animated:YES];
    }
}



#pragma mark - UIKeyInput Protocol

- (BOOL)hasText
{
    // there should always be a \n with the default format
    
    NSAttributedString *currentContent = self.attributedContentView.layoutFrame.attributedStringFragment;
    
    // has to have text
    if ([currentContent length]>1)
    {
        return YES;
    }
    
    // only a paragraph break = no text
    if ([[currentContent string] isEqualToString:@"\n"])
    {
        return NO;
    }
    
    // all other scenarios: no text
    return NO;
}

- (void)insertText:(NSString *)text
{
    
}

- (void)deleteBackward
{
    
}


#pragma mark UITextInput Protocol
#pragma mark -
/* Methods for manipulating text. */
- (NSString *)textInRange:(UITextRange *)range
{
    DTTextPosition *startPosition = (DTTextPosition *)range.start;
    DTTextPosition *endPosition = (DTTextPosition *)range.end;
    
    // on iOS 5 the upper end of the range might be "unbounded" (NSIntegerMax)
    if ([endPosition compare:(DTTextPosition *)self.endOfDocument]==NSOrderedDescending)
    {
        endPosition = (DTTextPosition *)self.endOfDocument;
    }
    
    range = [self textRangeFromPosition:startPosition toPosition:endPosition];
    NSAttributedString *fragment = [self attributedSubstringForRange:range];
    
    return [fragment string];
}

- (void)replaceRange:(DTTextRange *)range withText:(id)text
{
}



#pragma mark Working with Marked and Selected Text
- (DTTextRange *)selectedTextRange
{
    return (id)_selectedTextRange;
}
- (void)setSelectedTextRange:(DTTextRange *)selectedTextRange animated:(BOOL)animated
{
    UITextRange *newTextRange = selectedTextRange;
    
    if (selectedTextRange != nil)
    {
        // check if the selected range fits with the attributed text
        DTTextPosition *start = (DTTextPosition *)newTextRange.start;
        DTTextPosition *end = (DTTextPosition *)newTextRange.end;
        
        if ([end compare:(DTTextPosition *)[self endOfDocument]] == NSOrderedDescending)
        {
            end = (DTTextPosition *)[self endOfDocument];
        }
        
        if ([start compare:end] == NSOrderedDescending)
        {
            start = end;
        }
        
        newTextRange = [DTTextRange textRangeFromStart:start toEnd:end];
    }
    
    if (_selectedTextRange && [_selectedTextRange isEqual:selectedTextRange])
    {
        // no change
        return;
    }
    
    [self willChangeValueForKey:@"selectedTextRange"];
    
    _selectedTextRange = [newTextRange copy];
    
    [self didChangeValueForKey:@"selectedTextRange"];
    
    // Notify the editor delegate if not dragging
    if (_dragMode != DTDragModeCursor && _dragMode != DTDragModeCursorInsideMarking)
    {
        [self _editorViewDelegateDidChangeSelection];
    }
    
    [self updateCursorAnimated:animated];
    [self hideContextMenu];
    
    self.overrideInsertionAttributes = nil;
}

- (void)setSelectedTextRange:(DTTextRange *)newTextRange
{
    [self setSelectedTextRange:newTextRange animated:NO];
}

- (UITextRange *)markedTextRange
{
    // must return nil, otherwise backspacing acts weird
    if ([_markedTextRange isEmpty])
    {
        return nil;
    }
    
    return (id)_markedTextRange;
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{

}

- (void)unmarkText
{
    if (!_markedTextRange)
    {
        return;
    }
    
    self.markedTextRange = nil;
    
    [self updateCursorAnimated:NO];
}


#pragma mark Computing Text Ranges and Text Positions
- (UITextRange *)textRangeFromPosition:(DTTextPosition *)fromPosition toPosition:(DTTextPosition *)toPosition
{
    return [DTTextRange textRangeFromStart:fromPosition toEnd:toPosition];
}

- (UITextPosition *)positionFromPosition:(DTTextPosition *)position offset:(NSInteger)offset
{
    DTTextPosition *begin = (id)[self beginningOfDocument];
    DTTextPosition *end = (id)[self endOfDocument];
    
    if (offset<0)
    {
        if (([begin compare:position] == NSOrderedAscending))
        {
            NSInteger newLocation = position.location+offset;
            
            // position.location is unsigned, so we need to be careful to not underflow
            if (newLocation>(NSInteger)begin.location)
            {
                return [DTTextPosition textPositionWithLocation:newLocation];
            }
            else
            {
                return begin;
            }
        }
        else
        {
            return begin;
        }
    }
    
    if (offset>0)
    {
        DTTextPosition *newPosition = [DTTextPosition textPositionWithLocation:position.location+offset];
        
        // return new position if it is before the document end, otherwise return end
        if (([newPosition compare:end] == NSOrderedAscending))
        {
            return newPosition;
        }
        else
        {
            return end;
        }
    }
    
    return position;
}


// limits position to be inside the range
- (UITextPosition *)positionFromPosition:(UITextPosition *)position withinRange:(UITextRange *)range
{
    UITextPosition *beginningOfDocument = [self beginningOfDocument];
    UITextPosition *endOfDocument = [self endOfDocument];
    
    if ([self comparePosition:position toPosition:beginningOfDocument] == NSOrderedAscending)
    {
        // position is before begin
        return beginningOfDocument;
    }
    
    if ([self comparePosition:position toPosition:endOfDocument] == NSOrderedDescending)
    {
        // position is after end
        return endOfDocument;
    }
    
    // position is inside range
    return position;
}

// limits position to be in range and optionally skips list prefixes in the direction
- (UITextPosition *)positionSkippingFieldsFromPosition:(UITextPosition *)position withinRange:(UITextRange *)range inDirection:(UITextStorageDirection)direction
{
    NSInteger index = [(DTTextPosition *)position location];
    
    // skip over list prefix
    NSAttributedString *attributedString = self.attributedString;
    NSRange listPrefixRange = [attributedString rangeOfFieldAtIndex:index];
    
    UITextPosition *newPosition = position;
    
    if (listPrefixRange.location != NSNotFound)
    {
        // there is a prefix, skip it according to direction
        switch (direction)
        {
            case UITextStorageDirectionForward:
            {
                // position after prefix
                newPosition = [DTTextPosition textPositionWithLocation:NSMaxRange(listPrefixRange)];
                break;
            }
                
            case UITextStorageDirectionBackward:
            {
                // position before prefix
                UITextPosition *positionOfPrefix = [DTTextPosition textPositionWithLocation:listPrefixRange.location];
                newPosition = [self positionFromPosition:positionOfPrefix offset:-1];
                break;
            }
        }
    }
    
    // limit the position to be within the range
    return [self positionFromPosition:newPosition withinRange:range];
}


- (UITextPosition *)positionFromPosition:(DTTextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    UITextPosition *beginningOfDocument = (id)[self beginningOfDocument];
    UITextPosition *endOfDocument = (id)[self endOfDocument];
    UITextRange *entireDocument = [self textRangeFromPosition:beginningOfDocument toPosition:endOfDocument];
    
    // shift beginning over a list prefix
    endOfDocument = [self positionSkippingFieldsFromPosition:endOfDocument withinRange:entireDocument inDirection:UITextStorageDirectionBackward];
    
    // shift end over a list prefix
    beginningOfDocument = [self positionSkippingFieldsFromPosition:beginningOfDocument withinRange:entireDocument inDirection:UITextStorageDirectionForward];
    
    // update legal range
    UITextRange *maxRange = [self textRangeFromPosition:beginningOfDocument toPosition:endOfDocument];
    
    UITextPosition *maxPosition = [self positionWithinRange:maxRange farthestInDirection:direction];
    
    if ([self comparePosition:position toPosition:maxPosition] == NSOrderedSame)
    {
        // already at limit
        return nil;
    }
    
    UITextPosition *retPosition = nil;
    
    switch (direction)
    {
        case UITextLayoutDirectionRight:
        {
            UITextPosition *newPosition = [self positionFromPosition:position offset:1];
            
            // TODO: make the skipping direction dependend on the text direction in this paragraph
            retPosition = [self positionSkippingFieldsFromPosition:newPosition withinRange:entireDocument inDirection:UITextStorageDirectionForward];
            break;
        }
            
        case UITextLayoutDirectionLeft:
        {
            UITextPosition *newPosition = [self positionFromPosition:position offset:-1];
            
            // TODO: make the skipping direction dependend on the text direction in this paragraph
            retPosition = [self positionSkippingFieldsFromPosition:newPosition withinRange:entireDocument inDirection:UITextStorageDirectionBackward];
            break;
        }
            
        case UITextLayoutDirectionDown:
        {
            NSInteger index = [self.attributedContentView.layoutFrame indexForPositionDownwardsFromIndex:position.location offset:offset];
            
            // document ends
            if (index == NSNotFound)
            {
                return maxPosition;
            }
            
            UITextPosition *newPosition = [DTTextPosition textPositionWithLocation:index];
            
            // limit the position to be within the range and skip list prefixes
            retPosition = [self positionSkippingFieldsFromPosition:newPosition withinRange:entireDocument inDirection:UITextStorageDirectionForward];
            break;
        }
            
        case UITextLayoutDirectionUp:
        {
            NSInteger index = [self.attributedContentView.layoutFrame indexForPositionUpwardsFromIndex:position.location offset:offset];
            
            // nothing up there
            if (index == NSNotFound)
            {
                return maxPosition;
            }
            
            UITextPosition *newPosition = [DTTextPosition textPositionWithLocation:index];
            
            // limit the position to be within the range and skip list prefixes
            retPosition = [self positionSkippingFieldsFromPosition:newPosition withinRange:entireDocument inDirection:UITextStorageDirectionForward];
            break;
        }
    }
    
    return retPosition;
}

- (UITextPosition *)beginningOfDocument
{
    return [DTTextPosition textPositionWithLocation:0];
}

- (UITextPosition *)endOfDocument
{
    if ([self hasText])
    {
        return [DTTextPosition textPositionWithLocation:[self.attributedContentView.layoutFrame.attributedStringFragment length]-1];
    }
    
    return [self beginningOfDocument];
}

#pragma mark Evaluating Text Positions
- (NSComparisonResult)comparePosition:(DTTextPosition *)position toPosition:(DTTextPosition *)other
{
    return [position compare:other];
}

- (NSInteger)offsetFromPosition:(DTTextPosition *)fromPosition toPosition:(DTTextPosition *)toPosition
{
    return toPosition.location - fromPosition.location;
}

#pragma mark Determining Layout and Writing Direction
- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
    switch (direction)
    {
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:
            return [range end];
            
        case UITextLayoutDirectionLeft:
        case UITextLayoutDirectionUp:
            return [range start];
    }
}

- (UITextRange *)characterRangeByExtendingPosition:(DTTextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    [[NSException exceptionWithName:@"Not Implemented" reason:@"When is this method being used?" userInfo:nil] raise];
    
    DTTextPosition *end = (id)[self endOfDocument];
    
    return [DTTextRange textRangeFromStart:position toEnd:end];
}

// TODO: How is this implemented correctly?
- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    return UITextWritingDirectionLeftToRight;
}

// TODO: How is this implemented correctly?
- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{
    
}


#pragma mark - Utilities

- (CGRect)visibleContentRect
{
    CGRect rect = self.bounds;
    return rect;
}

- (BOOL)selectionIsVisible
{
    CGRect visibleContentRect = [self visibleContentRect];
    CGRect selectionRect = [self boundsOfCurrentSelection];
    
    // selection is visible if the selection rect is in the visible rect
    if (!CGRectIntersectsRect(visibleContentRect, selectionRect))
    {
        return NO;
    }
    
    return YES;
}

- (void)relayoutText
{
    [self.attributedContentView relayoutText];
}


#pragma mark - Delegate Communication

- (void)_inputDelegateSelectionWillChange
{
    [self.inputDelegate selectionWillChange:self];
}

- (void)_inputDelegateSelectionDidChange
{
    [self.inputDelegate selectionDidChange:self];
}

- (void)_inputDelegateTextWillChange
{
    [self.inputDelegate textWillChange:self];
}

- (void)_inputDelegateTextDidChange
{
    [self.inputDelegate textDidChange:self];
}

- (void)_editorViewDelegateDidChangeSelection
{
    if (_htmlViewDelegateFlags.delegateDidChangeSelection) {
        [_htmlViewDelegate htmlViewDidChangeSelection:self];
    }
}

#pragma mark - super method override


#pragma mark - properties

- (DTCursorView *)cursor
{
    if (!_cursor)
    {
        _cursor = [[DTCursorView alloc] initWithFrame:CGRectZero];
        [self addSubview:_cursor];
    }
    
    return _cursor;
}

- (DTTextSelectionView *)selectionView
{
    if (!_selectionView)
    {
        _selectionView = [[DTTextSelectionView alloc] initWithTextView:self.attributedContentView];
        [self addSubview:_selectionView];
    }
    
    return _selectionView;
}

// make sure that the selection rectangles are always in front of content view
- (void)addSubview:(UIView *)view
{
    
    [super addSubview:view];
    
    // content view should always be at back
    [self sendSubviewToBack:self.attributedContentView];
    
    // selection view should be in front of everything
    if (_selectionView)
    {
        [self bringSubviewToFront:_selectionView];
    }
}


- (void)setMarkedTextRange:(UITextRange *)markedTextRange
{
    if (markedTextRange != _markedTextRange)
    {
        [self willChangeValueForKey:@"markedTextRange"];
        
        _markedTextRange = [markedTextRange copy];
        
        [self hideContextMenu];
        
        [self didChangeValueForKey:@"markedTextRange"];
    }
}

- (void) setHtmlViewDelegate:(id<SSV2HtmlViewDelegate>)htmlViewDelegate
{
    _htmlViewDelegate = htmlViewDelegate;
    _htmlViewDelegateFlags.delegateWillPasteTextInRange = [htmlViewDelegate respondsToSelector:@selector(htmlView:willPasteText:inRange:)];
    _htmlViewDelegateFlags.delegateDidChangeSelection = [htmlViewDelegate respondsToSelector:@selector(htmlViewDidChangeSelection:)];
    _htmlViewDelegateFlags.delegateMenuItems = [htmlViewDelegate respondsToSelector:@selector(menuItems)];
    _htmlViewDelegateFlags.delegateCanPerformActionsWithSender = [htmlViewDelegate respondsToSelector:@selector(htmlView:canPerformAction:withSender:)];

}


@synthesize htmlViewDelegate = _htmlViewDelegate;
@synthesize selectionAffinity = _selectionAffinity;

@synthesize cursor = _cursor;
@synthesize markedTextRange = _markedTextRange;
@synthesize markedTextStyle = _markedTextStyle;

@synthesize editorMenuItems = _editorMenuItems;
// UITextInput
@synthesize autocapitalizationType;
@synthesize autocorrectionType;

@synthesize overrideInsertionAttributes = _overrideInsertionAttributes;
// other properties
@synthesize canInteractWithPasteboard = _canInteractWithPasteboard;
//@synthesize attributedContentView = _attributedContentView;


@end
