
import Foundation
import UIKit
import CoreData

enum App
{
	static let baseURL = URL(string:"https://pushier-and-postier.firebaseio.com/")!
	static var controller = EntryController()

	static func logError(_ completion:@escaping CompletionHandler, _ error:String)
	{
		NSLog(error)
		completion(error)
	}
}

typealias ErrorString = String
typealias CompletionHandler = (ErrorString?)->Void
let EmptyHandler:CompletionHandler = {_ in}
func buildRequest(_ ids:[String], _ httpMethod:String, _ data:Data?=nil) -> URLRequest
{
	var url = App.baseURL
	for id in ids {
		url.appendPathComponent(id)
	}
	url.appendPathExtension("json")
	var req = URLRequest(url: url)
	req.httpMethod = httpMethod
	req.httpBody = data
	return req
}

