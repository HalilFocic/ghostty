@testable import Ghostty
import AppKit
import Testing

struct SurfaceViewAppKitTests {
    @Test(arguments: [
        ("\u{0008}", true),
        ("\u{001F}", true),
        ("\u{007F}", false),
        (" ", false),
        ("h", false),
        ("", false),
        ("\u{0009}x", false),
        ("\u{0009}\u{0009}", false),
    ])
    func suppressesOnlySingleC0ControlTextWhileComposing(
        text: String,
        expected: Bool
    ) {
        #expect(
            Ghostty.SurfaceView.shouldSuppressComposingControlInput(
                text,
                composing: true
            ) == expected
        )
    }

    @Test func doesNotSuppressControlTextWhenNotComposing() {
        #expect(
            Ghostty.SurfaceView.shouldSuppressComposingControlInput(
                "\u{0008}",
                composing: false
            ) == false
        )
    }

    @Test func doesNotSuppressMissingText() {
        #expect(
            Ghostty.SurfaceView.shouldSuppressComposingControlInput(
                nil,
                composing: true
            ) == false
        )
    }

    @Test func mapsScrollingCommands() {
        #expect(
            Ghostty.SurfaceView.appKitKeyCommand(
                for: #selector(NSResponder.scrollToBeginningOfDocument(_:))
            ) == .top
        )
        #expect(
            Ghostty.SurfaceView.appKitKeyCommand(
                for: #selector(NSResponder.scrollToEndOfDocument(_:))
            ) == .bottom
        )
        #expect(
            Ghostty.SurfaceView.appKitKeyCommand(
                for: #selector(NSResponder.scrollPageUp(_:))
            ) == .pageUp
        )
        #expect(
            Ghostty.SurfaceView.appKitKeyCommand(
                for: #selector(NSResponder.scrollPageDown(_:))
            ) == .pageDown
        )
        #expect(
            Ghostty.SurfaceView.appKitKeyCommand(
                for: #selector(NSResponder.moveLeft(_:))
            ) == nil
        )
    }

    @Test func scrollingCommandsUseExistingBindingActions() {
        #expect(Ghostty.SurfaceView.AppKitKeyCommand.top.bindingAction == "scroll_to_top")
        #expect(Ghostty.SurfaceView.AppKitKeyCommand.bottom.bindingAction == "scroll_to_bottom")
        #expect(Ghostty.SurfaceView.AppKitKeyCommand.pageUp.bindingAction == "scroll_page_up")
        #expect(Ghostty.SurfaceView.AppKitKeyCommand.pageDown.bindingAction == "scroll_page_down")
    }

    @Test func performsScrollingCommandOnPrimaryScreen() {
        #expect(
            Ghostty.SurfaceView.appKitKeyCommandToPerform(
                .pageUp,
                ghosttyBindingExists: false,
                composing: false,
                accumulatedTextIsEmpty: true,
                isAlternateScreen: false
            ) == .pageUp
        )
    }

    @Test func forwardsScrollingCommandOnAlternateScreen() {
        #expect(
            Ghostty.SurfaceView.appKitKeyCommandToPerform(
                .pageUp,
                ghosttyBindingExists: false,
                composing: false,
                accumulatedTextIsEmpty: true,
                isAlternateScreen: true
            ) == nil
        )
    }
}
