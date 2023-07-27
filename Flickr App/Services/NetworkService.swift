//
//  NetworkService.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import Foundation
import Combine

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    private var cancellable = Set<AnyCancellable>()
    
    //MARK: - makeRequest
    func makeRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        //издатель
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        publisher.sink { result in
            switch result {
            case .finished:
                print("finished!")
            case .failure(let error):
                completion(.failure(error))
            }
        } receiveValue: { data in
            completion(.success(data))
        }.store(in: &cancellable)
    }
    
    //MARK: - makeRequestArrayData
    func makeRequestArrayData<T>(request: [URLRequest], completion: @escaping (Result<[T], Error>) -> Void) {
        let group = DispatchGroup()
        var dataArray = [Data?](repeating: nil, count: request.count)
        // Перебираем массив URL-адресов и выполняем запросы асинхронно
        for (index, urlRequest) in request.enumerated() {
            group.enter() // Вступаем в группу операций перед каждым запросом
            
            DispatchQueue.global(qos: .userInteractive).async {
                URLSession.shared.dataTask(with: urlRequest) { (data,
                                                                response,
                                                                error) in
                    // Обработка полученного ответа
                    dataArray[index] = data
                    
                    if dataArray[dataArray.count - 1] != nil {
                        DispatchQueue.main.async {
                            completion(.success(dataArray as? [T] ?? []))
                        }
                    }
                    group.leave() // Выходим из группы операций после обработки ответа
                }.resume()
            }
            group.wait()
        }
    }
}
