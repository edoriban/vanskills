---
name: react-native
description: >
  React Native patterns and best practices for cross-platform mobile development.
  Trigger: When building or modifying React Native applications.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Working with React Native components or APIs"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## When to Use

Use this skill when:
- Developing mobile applications using React Native.
- Implementing UI components using primitive components like `View`, `Text`, and `Image`.
- Handling platform-specific logic (iOS/Android).
- Optimizing mobile performance (lists, images, animations).

---

## Critical Patterns

React Native requires a mobile-first mindset, focusing on touch interactions, limited screen real estate, and performance constraints.

### Pattern 1: Primitive Components
Always use React Native primitives instead of HTML elements. Use `View` for containers and `Text` for all text content.

```tsx
import { View, Text, StyleSheet } from 'react-native';

const MyComponent = () => (
  <View style={styles.container}>
    <Text style={styles.text}>Hello React Native</Text>
  </View>
);
```

### Pattern 2: StyleSheet.create
Always use `StyleSheet.create` for styling to ensure styles are sent across the bridge only once and to enable better validation.

```tsx
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  text: {
    fontSize: 18,
    color: '#333',
  },
});
```

### Pattern 3: Platform Specifics
Use `Platform.select` or `.ios.js` / `.android.js` extensions for platform-specific logic.

```tsx
import { Platform, StyleSheet } from 'react-native';

const styles = StyleSheet.create({
  container: {
    paddingTop: Platform.OS === 'ios' ? 20 : 0,
    ...Platform.select({
      ios: { backgroundColor: 'red' },
      android: { backgroundColor: 'blue' },
    }),
  },
});
```

---

## Decision Tree

```
Long list of data? -> Use FlatList or SectionList
Fixed set of items? -> Use ScrollView
Touch interaction? -> Use Pressable (preferred) or TouchableOpacity
Responsive layout? -> Use Flexbox and useWindowDimensions
```

---

## Code Examples

### Example 1: High-Performance List
Using `FlatList` with `keyExtractor` and `renderItem` optimization.

```tsx
import { FlatList, Text, View } from 'react-native';

const DATA = [{ id: '1', title: 'Item 1' }];

const App = () => (
  <FlatList
    data={DATA}
    keyExtractor={item => item.id}
    renderItem={({ item }) => (
      <View>
        <Text>{item.title}</Text>
      </View>
    )}
  />
);
```

### Example 2: Handling Safe Areas
Ensuring content doesn't overlap with notches or status bars.

```tsx
import { SafeAreaView, Text, StyleSheet } from 'react-native';

const App = () => (
  <SafeAreaView style={styles.safeArea}>
    <Text>Content inside safe area</Text>
  </SafeAreaView>
);

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },
});
```

---

## Commands

```bash
npx react-native run-ios      # Run on iOS simulator
npx react-native run-android  # Run on Android emulator
npx react-native start        # Start Metro bundler
```

---

## Resources

- **Documentation**: [React Native Official Docs](https://reactnative.dev/docs/getting-started)
- **Navigation**: [React Navigation](https://reactnavigation.org/)
