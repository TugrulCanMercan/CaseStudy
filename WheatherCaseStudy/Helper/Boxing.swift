//
//  Boxing.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 4.04.2022.
//

import Foundation




class Disposable {
    let dispose: () -> Void
    init(_ dispose: @escaping () -> Void) { self.dispose = dispose }
    deinit { dispose() }
}


class Box<T> {
    typealias Listener = (T) -> Void

    // Replace your array with a dictionary mapping
    // I also made the Observer method mandatory. I don't believe it makes
    // sense for it to be optional. I also made it private.
    private var listeners: [UUID: Listener] = [:]

    var value: T {
        didSet {
            listeners.values.forEach { $0(value) }
        }
    }

    init(_ value: T){
        self.value = value
    }

    // Now return a Disposable. You'll get a warning if you fail
    // to retain it (and it will immediately be destroyed)
    func bind(listener: @escaping Listener) -> Disposable {

        // UUID is a nice way to create a unique identifier; that's what it's for
        let identifier = UUID()

        // Keep track of it
        self.listeners[identifier] = listener

        listener(value)

        // And create a Disposable to clean it up later. The Disposable
        // doesn't have to know anything about T.
        // Note that Disposable has a strong referene to the Box
        // This means the Box can't go away until the last observer has been removed
        return Disposable { self.listeners.removeValue(forKey: identifier) }
    }
}

class DisposeBag {
    private var disposables: [Disposable] = []
    func append(_ disposable: Disposable) { disposables.append(disposable) }
}

extension Disposable {
    func disposed(by bag: DisposeBag) {
        bag.append(self)
    }
}
