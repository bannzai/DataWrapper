// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: arbitrary)
public macro DataModel() = #externalMacro(module: "DataWrapperPlugin", type: "DataModelMacro")
