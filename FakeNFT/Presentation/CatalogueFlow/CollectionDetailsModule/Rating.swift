import UIKit

final class Rating {
    private(set) var image: UIImage = UIImage()
    
    init(_ number: Int) {
        self.image = getImageForRating(number)
    }
    
    private func getImageForRating(_ number: Int) -> UIImage {
        switch number {
        case 0: return Consts.Images.rating0
        case 1: return Consts.Images.rating1
        case 2: return Consts.Images.rating2
        case 3: return Consts.Images.rating3
        case 4: return Consts.Images.rating4
        case 5: return Consts.Images.rating5
        default: return Consts.Images.rating0
        }
    }
}
