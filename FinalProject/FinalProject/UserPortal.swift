//
//  UserPortal.swift
//  FinalProject
//
//  Created by Bradley Dodds on 12/9/19.
//  Copyright © 2019 351. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSCore
import AWSAuthCore
import AWSCognitoIdentityProvider
import AWSDynamoDB
import Foundation

struct messageCellStruct {
    
    let username: String!
    let message: String!
    let timestamp: String!
 
}

var messageArray = [messageCellStruct]()


class UserPortal: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    let userMessage = Messages()
    var cognitoUserID = ""
    var username = ""
    var timestamp = ""
    var scanBool = false
   // let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 8
        tableView.delegate = self
        tableView.dataSource = self
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
          // TODO: - whatever you want
            
            if(self.scanBool == false){
                messageArray.removeAll()
                self.scan()
            }
        
       }

        

        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //saveMessage()
        awsCredentials()
    }
    
    @objc func sayHello()
    {
        NSLog("hello World")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let userMessage = cell.viewWithTag(1) as! UILabel
        let un = cell.viewWithTag(2) as! UILabel
        let time = cell.viewWithTag(3) as! UILabel
        
        userMessage.text = messageArray[indexPath.row].message
        un.text = messageArray[indexPath.row].username
        time.text = messageArray[indexPath.row].timestamp
        
        
        return cell
    }
    
    
    
    
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        saveMessage()
    
    }
    
    
    func saveMessage() {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowString = dateFormatter.string(from: now)
        
        userMessage?._message = messageField.text
        userMessage?._userId = cognitoUserID
        userMessage?._username = username
        userMessage?._timestamp = nowString
        
        print(userMessage?._message)
        print(userMessage?._userId)
        print(userMessage?._username)
        print(userMessage?._timestamp)
        
    
        
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
         
        
         dynamoDBObjectMapper.save(userMessage!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
             if let error = task.error as NSError? {
                 //print(self.userMessage as Any)
                 print("The request failed. Error: \(error)")
             } else {
                 // Do something with task.result or perform other operations.
                 print("result sent")
                 //self.scan()
                
                 
             }
             
             return nil
             
         })
        
        
        
        
    }
    
    
    
    
    func scan() {
        
        scanBool = true
        
       let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let scanExpression = AWSDynamoDBScanExpression()
        
         scanExpression.limit = 20
        

        dynamoDBObjectMapper.scan(Messages.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject? in

        if task.result != nil {
            let paginatedOutput = task.result!
            
            messageArray.removeAll()

            //use the results
            for item in paginatedOutput.items as! [Messages] {
                //print(item._message)
                //print(item._userId)
                //print("\n")
                
                //timeAgoSinceDate - Format and call function to recieve time of post
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let timeStampDate = dateFormatter.date(from: String(item._timestamp!))
                let timeStampNew = timeAgoSinceDate(date: timeStampDate!, numericDates: false)
                
                
                
                messageArray.insert(messageCellStruct(username: String(item._message!), message: String(item._username!), timestamp: timeStampNew), at: 0)
            }

            if ((task.error) != nil) {
                print("Error: \(String(describing: task.error))")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
           
            return nil

        }

        
        return nil
        })
        
        
        //messageArray.sort(by: { $0.timestamp.compare($1.timestamp) == .orderedAscending })
        //self.tableView.reloadData()
        scanBool = false
        
    }
    
    
    
    
    func awsCredentials() {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast2, identityPoolId: "us-east-2:c1c9c77a-bc34-49d8-b9b1-adc9d764570c")
        let configuration = AWSServiceConfiguration(region: .USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        // Retrieve your Amazon Cognito ID
        credentialsProvider.getIdentityId().continueWith(block: { (task) -> AnyObject? in
            if (task.error != nil) {
                print("Error: " + task.error!.localizedDescription)
            }
            else {
                // the task result will contain the identity id
                let cognitoId = task.result!
                self.cognitoUserID = String(cognitoId)
                self.username = String(AWSMobileClient.default().username!)
                
                print("Cognito id: \(cognitoId)")
                print("credentials are configured")
            }
            return task;
        })
        
        
        
    }
    
    
    
    


}// END UserPortal



