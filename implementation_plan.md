# Revert Rich Text Editor to Original Layout

The goal is to revert the recently added rich text editor (Flutter Quill) on the Home Screen back to the previous design, which used the `GoldTextArea` and `TextEditorTools`. This will restore the layout the user is familiar with, fix the white box issue, and ensure the "Next" button activates correctly when typing plain text content.

## User Review Required
- The formatting (bold, italic, alignment, font size) applied by the restored `TextEditorTools` will apply to the *entire* text block globally, as it did before, rather than applying rich text formatting to specific words. Is this acceptable? (Since you requested a revert to how it was before, this is the expected behavior).
- We will remove the `flutter_quill` package and any associated logic to clean up the codebase.

## Proposed Changes

### `lib/screens/home_screen.dart`
- **[MODIFY]**: Remove all `quill.QuillController` and `quill.QuillSimpleToolbar` references.
- **[MODIFY]**: Re-introduce the `_contentController` (TextEditingController) for the content input.
- **[MODIFY]**: Replace the `QuillEditor` container with the original `GoldTextArea`.
- **[MODIFY]**: Replace the `QuillSimpleToolbar` with the original `TextEditorTools` widget below the content area.
- **[MODIFY]**: Update the "Discard" and "Next" buttons to rely on `_contentController.text.trim().isNotEmpty` instead of Quill's document state.
- **[MODIFY]**: Ensure `appState.setContent(_contentController.text)` is called correctly so the preview renders the text.

### `lib/providers/app_state_provider.dart`
- **[MODIFY]**: Remove the `setQuillDeltaJson` method and restore reliance on `setContent()`.

### `lib/models/card_config.dart`
- **[MODIFY]**: Remove the `quillDeltaJson` property from the configuration model.

### `pubspec.yaml`
- **[MODIFY]**: Remove the `flutter_quill` package dependency.

### `lib/utils/delta_to_textspan.dart`
- **[DELETE]**: Remove this utility file as we no longer need to parse Quill deltas.

## Verification Plan

### Manual Verification
- Run the application and open the Home screen.
- Verify the layout looks identical to the original version (Topic, Subtopic, Content textarea, and tool buttons).
- Type in the Content area and ensure the "Next" button activates immediately.
- Test the formatting toggles (Bold, Italic, Alignment, Font Size) to ensure they update the app state correctly and apply to the preview card.
