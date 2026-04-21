import UIKit
import CoreImage.CIFilterBuiltins

@MainActor
extension UIImage {

    private static let desaturationContext = CIContext()
    private static let desaturationCache = NSMapTable<UIImage, UIImage>.weakToStrongObjects()

    /* Возвращает grayscale-версию изображения через CIColorControls (saturation = 0).
       Результат кешируется по identity оригинала. Возвращает nil при ошибке фильтра. */
    public func desaturated() -> UIImage? {
        if let cached = Self.desaturationCache.object(forKey: self) { return cached }
        guard let ciImage = CIImage(image: self) else { return nil }
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.saturation = 0
        guard let output = filter.outputImage,
              let cgImage = Self.desaturationContext.createCGImage(output, from: output.extent)
        else { return nil }
        let result = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        Self.desaturationCache.setObject(result, forKey: self)
        return result
    }
}
