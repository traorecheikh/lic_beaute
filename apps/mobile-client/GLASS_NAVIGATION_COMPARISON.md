# iOS Liquid Glass Navigation: Package Comparison

## Summary
Both packages implement iOS 26 Liquid Glass styling, but use fundamentally different approaches with different tradeoffs.

---

## cupertino_native_better

### Setup Complexity
**Medium**
- Add to `pubspec.yaml`: `cupertino_native_better: ^1.5.0`
- Import package
- Register `CNTabBarRouteObserver` in MaterialApp/GoRouter
- **One-time setup, but requires coordination**

### Platform Support
- **iOS 26+**: Native UIKit Liquid Glass
- **iOS 13-25**: Cupertino widgets (fallback)
- **Android/Web**: Material fallback

### Maintenance Status
- **Version**: 1.5.0
- **Published**: 19 days ago
- **Status**: Active, verified publisher
- **Downloads**: 5.5K
- **Repository**: https://github.com/gunumdogdu/cupertino_native_better

### Key Features
- **CNTabBar**: Native iOS 26 tab bar with split mode for scroll-aware layouts
- **CNSearchBar**: Native iOS 26 search bar
- **LiquidGlassContainer**: Apply glass effects to any widget (⚠️ NOT for scrollable lists)
- **Version Detection**: Reliable iOS version detection (no null check failures in release)
- **Glass Effect Unioning**: Multiple widgets can share unified glass effect

### Performance Considerations
⚠️ **CRITICAL**: Uses Platform Views (UiKitView/AppKitView) under the hood
- **DO NOT use** inside `ListView.builder` or other scrolling lists
- Significant performance drops with many items
- **Recommended for**: Static elements only (Cards, Headers, Navigation Bars, FABs)

### Pros
- ✅ Pixel-perfect native iOS 26 fidelity
- ✅ Reliable version detection (no release build bugs)
- ✅ Native SF Symbols support
- ✅ Automatic dark mode sync
- ✅ Glass effect unioning for consistent styling

### Cons
- ❌ Platform-view performance issues in scrolling lists
- ❌ Requires NavigatorObserver registration
- ❌ iOS 26+ only for full Liquid Glass (older iOS gets Cupertino fallback)
- ❌ More complex integration with existing Flutter navigation

---

## liquid_glass_widgets

### Setup Complexity
**Low**
- Add to `pubspec.yaml`: `liquid_glass_widgets: ^0.17.1`
- Call `LiquidGlassWidgets.initialize()` in `main()`
- Wrap app with `LiquidGlassWidgets.wrap(child: myApp)`
- **One-line setup, very easy**

### Platform Support
- **iOS**: Impeller (Metal) with full shader pipeline
- **Android**: Impeller (Vulkan) with full shader pipeline
- **macOS**: Impeller (Metal) with full shader pipeline
- **Web**: CanvasKit with lightweight shaders
- **Windows/Linux**: Skia with lightweight shaders
- **Cross-platform out of the box**

### Maintenance Status
- **Version**: 0.17.1
- **Published**: 17 hours ago (very recent!)
- **Status**: Active, maintained
- **Downloads**: 25.2K
- **Repository**: https://github.com/sdegenaar/liquid_glass_widgets

### Key Features
- **GlassBottomBar**: Glassmorphism bottom navigation bar
- **GlassSearchableBottomBar**: Apple Music-style morphing search bar
- **GlassTabBar**: Tab bar with glass styling
- **GlassAppBar**: Glass app bar
- **GlassScaffold**: Complete scaffold replacement with automatic background, z-ordering, edge fading
- **Content-Aware Brightness**: Bars adapt icon color to background content
- **Adaptive Quality**: Auto-benchmarks device and adjusts quality (minimal/standard/premium)
- **GPU Budget Monitoring**: Prevents thermal throttling

### Performance Considerations
- ✅ No platform-view overhead
- ✅ Standard quality for scrollable content (minimal shader cost)
- ✅ Premium quality for static surfaces (hero sections, app bars, bottom bars)
- ✅ Minimal quality for shader-dense screens
- ✅ Accessibility: Reduce Motion and Reduce Transparency respected automatically

### Pros
- ✅ Cross-platform (iOS, Android, macOS, Web, Windows, Linux)
- ✅ Lightweight shader-based approach (no platform-view overhead)
- ✅ Excellent performance in scrolling lists
- ✅ Content-aware brightness adaptation
- ✅ Adaptive quality for different devices
- ✅ Minimal dependencies (equatable, flutter_shaders, logging)
- ✅ Very easy integration

### Cons
- ❌ Less "native" than cupertino_native_better (shader-based, not UIKit)
- ❌ Newest package (0.17.1, just published 17 hours ago)
- ❌ Glass effects may not match iOS 26 exactly on all platforms
- ❌ Requires shader initialization in main()

---

## Recommendation for Bottom Nav + Search Bar

### For Bottom Navigation Bar:
**Winner: liquid_glass_widgets**
- ✅ No platform-view performance issues
- ✅ `GlassBottomBar` designed for scrolling content
- ✅ Content-aware brightness works perfectly with scrolling lists
- ✅ Cross-platform consistency

### For Search Bar:
**Winner: liquid_glass_widgets**
- ✅ `GlassSearchableBottomBar` with Apple Music-style morphing
- ✅ Works on all platforms
- ✅ No performance concerns
- ✅ `GlassScaffold` handles z-ordering automatically

### Why NOT cupertino_native_better:
- ❌ CNTabBar is designed for scroll-aware layouts but uses platform views
- ❌ Risk of performance degradation in salon list scrolling
- ❌ Only works on iOS 26+ for full Liquid Glass
- ❌ Requires complex NavigatorObserver coordination

---

## Final Verdict

**Choose liquid_glass_widgets for this project because:**

1. **Performance**: No platform-view overhead means smooth scrolling in salon lists
2. **Cross-platform**: Works on both iOS and Android consistently
3. **Ease of use**: One-line setup, automatic theming
4. **Content-aware brightness**: Perfect for a discovery app with scrolling content
5. **Maturity**: Despite being new, has strong architecture and active development

**Use cupertino_native_better only if:**
- You want pixel-perfect native UIKit fidelity
- You're targeting iOS 26+ exclusively
- You accept the platform-view performance tradeoff