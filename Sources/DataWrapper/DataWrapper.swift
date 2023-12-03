// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member) @attached(peer)
public macro DataModel() = #externalMacro(module: "DataWrapperPlugin", type: "DataModelMacro")
