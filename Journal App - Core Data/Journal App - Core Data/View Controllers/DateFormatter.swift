
import Foundation

struct DateFormat {
    static var dateFormatter: DateFormatter {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
        
    }
    
    let timestamp: Date = Date()
    

}
