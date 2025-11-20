import UIKit
import AVFoundation
import CoreImage

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    private let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let videoQueue = DispatchQueue(label: "video.queue")

    private let imageView = UIImageView()
    private let ciContext = CIContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupImageView()
        setupCamera()
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill   // 🔴 ÖNEMLİ: Fit değil Fill
        imageView.clipsToBounds = true             // Taşan kısmı kes
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView)
    }

    private func setupCamera() {
        session.beginConfiguration()
        session.sessionPreset = .high

        // Arka kamera
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input)
        else {
            print("Kamera input eklenemedi")
            return
        }
        session.addInput(input)

        // BGRA formatı
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        videoOutput.alwaysDiscardsLateVideoFrames = true

        guard session.canAddOutput(videoOutput) else {
            print("Video output eklenemedi")
            return
        }
        session.addOutput(videoOutput)

        if let connection = videoOutput.connection(with: .video),
           connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait   // 📱 Cihaz dikey
        }

        session.commitConfiguration()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }

    // Her frame geldiğinde
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, [])

        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
            return
        }

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)

        // C grayscale filtresi
        apply_grayscale_to_bgra(baseAddress,
                                Int32(width),
                                Int32(height),
                                Int32(bytesPerRow))

        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])

        // 🔴 Burada CIImage'ı oluşturup PORTRE yönüne çeviriyoruz
        // Arka kamerada portre için çoğu cihazda .right iyi çalışır
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        // 🔴 width/height DEĞİL, CIImage'ın kendi extent'i!
        let rect = ciImage.extent

        guard let cgImage = ciContext.createCGImage(ciImage, from: rect) else {
            return
        }

        let uiImage = UIImage(cgImage: cgImage)

        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = uiImage
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    
    deinit {
        print("DEINIT")
        session.stopRunning()
    }
}
