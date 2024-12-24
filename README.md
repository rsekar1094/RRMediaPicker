# **Media Picker**

This repository provides a powerful and flexible Media Picker framework for iOS applications. It supports selecting images, videos, or both, with options for single or multiple selections. The source types include the device's gallery, camera, and document picker.

## **Features**

- **Media Selection**:
  - Single or multiple media selection.
  - Supports images and videos.
  - Option to pick both images and videos simultaneously.

- **Source Types**:
  - **Gallery**: Select media from the photo library.
  - **Camera**: Capture images or videos directly.
  - **Documents**: Select media files from the device’s document picker.

- **Customizable**:
  - Define input types (images, videos, or both).
  - Set selection limits (e.g., single or unlimited selection).

## **Prerequisites**

- iOS 15.0 or later.
- Swift 5.5 or later.

## **Installation**

1. Clone the repository.
2. Integrate the framework into your project using Swift Package Manager or manually.

## **Usage**

### **MediaPickerView**

`MediaPickerView` is the main view component for presenting the media picker. It provides options for source type, input type, and selection limits.

### **Example Usage**

Here is an example implementation of `MediaPickerView`:

```swift
  MediaPickerView(
                isPresenting: $isMediaPickerSelected,
                isProcessing: $isMediaPickerProcessing,
                viewModel: .init(
                    sourceType: selectedSourceType,
                    inputType: .bothImageAndVideo,
                    selectionLimit: 0
                ),
                selection: { data in
                    var types: [MediaType] = []
                    types.append(contentsOf: data.videos.map { .video(.local($0)) })
                    types.append(contentsOf: data.images.map { .image(.local($0)) })

                    self.selectedMediaTypes = types
                }
            )
```

### **Parameters**

- `isPresenting`: A binding to control the presentation state of the picker.
- `isProcessing`: A binding to indicate whether the picker is processing the selection.
- `viewModel`: The configuration for the media picker, including:
  - `sourceType`: Specifies the source type (e.g., gallery, camera, documents).
  - `inputType`: Specifies the input type (images, videos, or both).
  - `selectionLimit`: Limits the number of selections (0 for unlimited).
- `selection`: A callback that returns the selected media data, which includes arrays of images and videos.

## **Supported Source Types**

1. **Gallery**:
   - Access media from the device’s photo library.
   ```swift
   viewModel.sourceType = .gallery
   ```

2. **Camera**:
   - Capture media directly using the camera.
   ```swift
   viewModel.sourceType = .camera
   ```

3. **Documents**:
   - Pick media files from the device’s document picker.
   ```swift
   viewModel.sourceType = .documents
   ```



https://github.com/user-attachments/assets/9da6e060-d445-4118-9eea-531e9245524b



## **Notes**

- Ensure the app has the necessary permissions for accessing the camera, photo library, or documents.
- This framework is highly customizable and can be extended to support additional functionalities.

## **License**

This project is available under the [MIT License](LICENSE).

