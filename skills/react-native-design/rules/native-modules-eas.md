# Native Module Integration and EAS Build

## Native Feature Examples

### Haptics and Biometrics

```tsx
// services/haptics.ts
import * as Haptics from 'expo-haptics'
import { Platform } from 'react-native'

export const haptics = {
  light: () => {
    if (Platform.OS !== 'web') {
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light)
    }
  },
}

// services/biometrics.ts
import * as LocalAuthentication from 'expo-local-authentication'

export async function authenticateWithBiometrics(): Promise<boolean> {
  const hasHardware = await LocalAuthentication.hasHardwareAsync()
  if (!hasHardware) return false

  const isEnrolled = await LocalAuthentication.isEnrolledAsync()
  if (!isEnrolled) return false

  const result = await LocalAuthentication.authenticateAsync({
    promptMessage: 'Authenticate to continue',
    fallbackLabel: 'Use passcode',
  })

  return result.success
}
```

## High-Performance Lists

```tsx
// components/ProductList.tsx
import { FlashList } from '@shopify/flash-list'
import { memo, useCallback } from 'react'

export function ProductList({ products, onProductPress }) {
  const renderItem = useCallback(
    ({ item }) => <ProductItem item={item} onPress={onProductPress} />,
    [onProductPress]
  )

  return (
    <FlashList
      data={products}
      renderItem={renderItem}
      keyExtractor={(item) => item.id}
      estimatedItemSize={100}
      removeClippedSubviews={true}
    />
  )
}
```

## EAS Build Configuration

```json
// eas.json
{
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "ios": { "simulator": true }
    },
    "preview": {
      "distribution": "internal",
      "android": { "buildType": "apk" }
    },
    "production": {
      "autoIncrement": true
    }
  }
}
```
