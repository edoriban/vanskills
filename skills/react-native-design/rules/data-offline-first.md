# Data Management and Offline-First Patterns

## Offline-First with React Query

```tsx
// providers/QueryProvider.tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { createAsyncStoragePersister } from '@tanstack/query-async-storage-persister'
import { PersistQueryClientProvider } from '@tanstack/react-query-persist-client'
import AsyncStorage from '@react-native-async-storage/async-storage'
import NetInfo from '@react-native-community/netinfo'
import { onlineManager } from '@tanstack/react-query'

// Sync online status
onlineManager.setEventListener((setOnline) => {
  return NetInfo.addEventListener((state) => {
    setOnline(!!state.isConnected)
  })
})

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      gcTime: 1000 * 60 * 60 * 24, // 24 hours
      staleTime: 1000 * 60 * 5,    // 5 minutes
      retry: 2,
      networkMode: 'offlineFirst',
    },
  },
})

const asyncStoragePersister = createAsyncStoragePersister({
  storage: AsyncStorage,
  key: 'REACT_QUERY_OFFLINE_CACHE',
})

export function QueryProvider({ children }: { children: React.ReactNode }) {
  return (
    <PersistQueryClientProvider
      client={queryClient}
      persistOptions={{ persister: asyncStoragePersister }}
    >
      {children}
    </PersistQueryClientProvider>
  )
}
```

## Optimistic Mutations

```tsx
// hooks/useProducts.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'

export function useCreateProduct() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: api.createProduct,
    onMutate: async (newProduct) => {
      await queryClient.cancelQueries({ queryKey: ['products'] })
      const previous = queryClient.getQueryData(['products'])

      queryClient.setQueryData(['products'], (old: Product[]) => [
        ...old,
        { ...newProduct, id: 'temp-' + Date.now() },
      ])

      return { previous }
    },
    onError: (err, newProduct, context) => {
      queryClient.setQueryData(['products'], context?.previous)
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['products'] })
    },
  })
}
```
