import Foundation

struct PaymentResponseResult: Codable {
    let success: Bool
    let orderId: String
    let id: String
    
    func convert() -> PaymentResponse {
        PaymentResponse(
            success: self.success,
            orderId: self.orderId,
            id: self.id
        )
    }
}
