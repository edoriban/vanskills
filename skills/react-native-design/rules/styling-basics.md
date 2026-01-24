# Styling Basics in React Native

## StyleSheet Basics

```tsx
import { StyleSheet, View, Text } from 'react-native';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#ffffff',
  },
  title: {
    fontSize: 24,
    fontWeight: '600',
    color: '#1a1a1a',
    marginBottom: 8,
  },
});
```

## Dynamic Styles

```tsx
interface CardProps {
  variant: 'primary' | 'secondary';
  disabled?: boolean;
}

function Card({ variant, disabled }: CardProps) {
  return (
    <View style={[
      styles.card,
      variant === 'primary' ? styles.primary : styles.secondary,
      disabled && styles.disabled,
    ]}>
      <Text style={styles.text}>Content</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    padding: 16,
    borderRadius: 12,
  },
  primary: { backgroundColor: '#6366f1' },
  secondary: { backgroundColor: '#f3f4f6', borderWidth: 1, borderColor: '#e5e7eb' },
  disabled: { opacity: 0.5 },
  text: { fontSize: 16 },
});
```
