# Injected

Dependency Injection using Swift Property Wrappers

### How to use?

Define dependencies (e.g. in AppDelegate) that need to be injected via property:

```swift
let dependencies = Dependencies {
    Dependency { LocationService() }
    Dependency { StorageService() }
    // ...
}
```

Build when it's needed (e.g. in Scene willConnectTo):

```swift
dependencies.build()
```

Define injected properties:

```swift
@Injected var location: LocationService
@Injected var storage: StorageService
```

Iterate over all dependencies:

```swift
for service in dependencies {
    service.start()
}
```

Access using dynamic member lookup:

```swift
let location: LocationProtocol? = dependencies.locationService // Erase type to protocol
let storage: StorageService = dependencies.storageService! // Force unwarp if needed
```

More details on implementation and usage is [here](https://grigory.nl/posts/swift-property-wrappers/)

### How to add it to Xcode project?

1. In Xcode select **File ⭢ Swift Packages ⭢ Add Package Dependency...**
1. Copy-paste repository URL: **https://github.com/avdyushin/Injected**
1. Hit **Next** two times, under **Add to Target** select your build target.
1. Hit **Finish**
