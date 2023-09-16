//
//  NewsFetchInteractor.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/16/23.
//

import Foundation

actor NewsStorage {
    private var news: [News] = []

    func store(date: String, news: News) {
        self.news.append(news)
        if self.news.count > 4 {
            self.news = self.news.suffix(4)
        }
    }

    func newsList() -> [News] {
        self.news
    }
}

final class NewsFetchInteractor {

    static let shared = NewsFetchInteractor()

    private(set) var storage = NewsStorage()

    init() {
        Task {
            while true {
                let newsList = await ServiceAPI().news5Minutes()
                for news in newsList.prefix(10) {
                    await self.storage.store(date: news.date, news: news)
                }
                try? await Task.sleep(seconds: 1)
            }
        }
    }
}
