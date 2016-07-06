//
//  main.swift
//  WtfIsMyIp-Parser
//
//  Created by Ryan Breaker on 7/3/16.
//  Copyright © 2016 Ryan Breaker. All rights reserved.
//

import Foundation

class ParserDelegate: NSObject, NSXMLParserDelegate {
    private enum ElementType: String {
        case IP       = "your-fucking-ip-address"
        case Location = "your-fucking-location"
        case Hostname = "your-fucking-hostname"
        case ISP      = "your-fucking-isp"
    }

    private var currentElement: ElementType? = nil
    private var usedElements = [ElementType]()

    func parser(parser: NSXMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {
        currentElement = ElementType.init(rawValue: elementName)
    }

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if let currentElement = currentElement {
            if !usedElements.contains(currentElement) {
                printElement(currentElement, characters: string)
                usedElements.append(currentElement)
            }
        }
    }

    private func printElement(element: ElementType, characters: String) {
        let line: String

        switch element {
        case .IP:
            line = "IP:       \(characters)"
        case .Location:
            line = "Location: \(characters)"
        case .Hostname:
            line = "Hostname: \(characters)"
        case .ISP:
            line = "ISP:      \(characters)"
        }

        print(line)
    }

    func run() {
        let parser = NSXMLParser(contentsOfURL: NSURL(string: "https://wtfismyip.com/xml")!)

        if let parser = parser {
            parser.delegate = self
            parser.parse()
        } else {
            print("Error!")
            exit(1)
        }
    }
}

// Run!
ParserDelegate().run()
