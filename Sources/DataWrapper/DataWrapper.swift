// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(peer, names: suffixed(Data))
public macro DataModel() = #externalMacro(module: "DataWrapperPlugin", type: "DataModelMacro")
