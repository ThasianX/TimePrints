import Mapbox

class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}

extension CustomAnnotationView {
    static func makeDefault(identifier: String?) -> CustomAnnotationView {
        let annotationView = CustomAnnotationView(reuseIdentifier: identifier)
        annotationView.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        return annotationView
    }
}
