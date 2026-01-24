# Layout and Platform-Specific Styling

## Flexbox Layout

```tsx
const styles = StyleSheet.create({
  // Vertical stack (column)
  column: {
    flexDirection: 'column',
    gap: 12,
  },
  // Horizontal stack (row)
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  // Space between items
  spaceBetween: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  // Centered content
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
```

## Platform-Specific Styling

```tsx
import { Platform, StyleSheet } from 'react-native';

const styles = StyleSheet.create({
  container: {
    padding: 16,
    ...Platform.select({
      ios: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
      },
      android: {
        elevation: 4,
      },
    }),
  },
  text: {
    fontFamily: Platform.OS === 'ios' ? 'SF Pro Text' : 'Roboto',
    fontSize: 16,
  },
});
```
