# Project Structure and Setup

## Recommended Structure

```
src/
├── app/                    # Expo Router screens
│   ├── (auth)/            # Auth group
│   ├── (tabs)/            # Tab navigation
│   └── _layout.tsx        # Root layout
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
npx expo install expo-router expo-status-bar react-native-safe-area-context
npx expo install @react-native-async-storage/async-storage expo-secure-store

# Navigation
router.push('/profile/123')           # Push screen
router.replace('/login')              # Replace screen
router.back()                         # Go back

# OTA Updates
eas update --branch production --message "Bug fixes"

# Submit to stores
eas submit --platform ios
eas submit --platform android
```
