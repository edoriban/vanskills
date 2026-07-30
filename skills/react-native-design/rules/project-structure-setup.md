# Project Structure and Setup

## Recommended Structure

```
src/
├── screens/                # Screen components (React Navigation)
├── navigation/             # Navigators (stacks, tabs) and param types
├── components/
│   ├── ui/                # Reusable UI components
│   └── features/          # Feature-specific components
├── hooks/                 # Custom hooks
├── services/              # API and native services
├── stores/                # State management
├── utils/                 # Utilities
└── types/                 # TypeScript types
```

## Decision Tree

```
New project?           -> Use Expo with create-expo-app
Need custom native?    -> Use EAS Build + config plugins
Long lists?            -> Use FlashList (not FlatList)
Offline support?       -> Use React Query + AsyncStorage persister
Auth flow?             -> Use SecureStore + route protection
Animations?            -> Use Reanimated (native thread)
```

## Essential Commands

```bash
# Create project
npx create-expo-app@latest my-app -t expo-template-blank-typescript

# Install essentials
npx expo install @react-navigation/native @react-navigation/native-stack react-native-screens
npx expo install expo-status-bar react-native-safe-area-context
npx expo install @react-native-async-storage/async-storage expo-secure-store

# OTA Updates
eas update --branch production --message "Bug fixes"

# Submit to stores
eas submit --platform ios
eas submit --platform android
```
