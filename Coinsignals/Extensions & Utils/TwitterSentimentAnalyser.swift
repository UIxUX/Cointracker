//
//  TwitterSentimentAnalyser.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/24/18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation
import SwifteriOS
import SwiftyJSON
import CoreML

/// Mark - From a CoreML Tutorial

struct TwitterSentimentAnalyser {
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    func getSentimentScoreFor(string: String, completion: @escaping ((Int) -> Void)){
        /// No problem to store secret here as it is from a CoreMl tutorial
        let swifter = Swifter(consumerKey: "LTReJyreyyuz4SWjVABuA1WKI", consumerSecret: "ajf107xfd6869heCG8Ptn8iztfFHBWPIxLkFGvsmoEwI7MKZcz")
        var sentimentScore: Int! = 0
        print("swifter: \(swifter)")
        /// First get Tweets from Twitter API
        swifter.searchTweet(using: string, lang: "en", count: Constants.amountOfTweetsForSentimentAnalysis, tweetMode: .extended, success: { (results, metadata) in
            var tweets = [TweetSentimentClassifierInput]()
            for i in 0..<Constants.amountOfTweetsForSentimentAnalysis {
                if let tweet = results[i]["full_text"].string {
                    let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                    tweets.append(tweetForClassification)
                }
                print("tweets: \(tweets)")
            }
            
            /// Predict
            do {
                let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                
                sentimentScore = 0
                
                for pred in predictions {
                    let sentiment = pred.label
                    
                    if sentiment == "Pos" {
                        sentimentScore += 1
                    } else if sentiment == "Neg" {
                        sentimentScore -= 1
                    }
                }
                print("final SentimentScore: \(sentimentScore)")
                completion(sentimentScore)
            } catch {
                print("ERROR with prediction: \(error)")
            }
            
        }) { (error) in
            print("ERROR with getting tweets: \(error)")
        }
    }
    
    
    
}
