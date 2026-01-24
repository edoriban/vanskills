# Security Checklists & OWASP Top 10

## Common Pitfalls

### Problem: JWT Secret Exposed in Code
**Symptoms:** JWT secret hardcoded or committed to Git
**Solution:**
```javascript
// ❌ Bad
const JWT_SECRET = 'my-secret-key';

// ✅ Good
const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) {
  throw new Error('JWT_SECRET environment variable is required');
}
```

### Problem: Weak Password Requirements
**Symptoms:** Users can set weak passwords like "password123"
**Solution:**
```javascript
const passwordSchema = z.string()
  .min(12, 'Password must be at least 12 characters')
  .regex(/[A-Z]/, 'Must contain uppercase letter')
  .regex(/[a-z]/, 'Must contain lowercase letter')
  .regex(/[0-9]/, 'Must contain number')
  .regex(/[^A-Za-z0-9]/, 'Must contain special character');
```

### Problem: Missing Authorization Checks
**Symptoms:** Users can access resources they shouldn't
**Solution:**
```javascript
// ✅ Good: Checks both authentication and authorization
app.delete('/api/posts/:id', authenticateToken, async (req, res) => {
  const post = await prisma.post.findUnique({
    where: { id: req.params.id }
  });
  
  if (!post) {
    return res.status(404).json({ error: 'Post not found' });
  }
  
  // Check if user owns the post or is admin
  if (post.userId !== req.user.userId && req.user.role !== 'admin') {
    return res.status(403).json({ 
      error: 'Not authorized to delete this post' 
    });
  }
  
  await prisma.post.delete({ where: { id: req.params.id } });
  res.json({ success: true });
});
```

### Problem: Verbose Error Messages
**Symptoms:** Error messages reveal system details
**Solution:**
```javascript
// ✅ Good: Generic error message
app.post('/api/users', async (req, res) => {
  try {
    const user = await prisma.user.create({ data: req.body });
    res.json(user);
  } catch (error) {
    console.error('User creation error:', error); // Log full error
    
    if (error.code === 'P2002') {
      return res.status(400).json({ 
        error: 'Email already exists' 
      });
    }
    
    res.status(500).json({ 
      error: 'An error occurred while creating user' 
    });
  }
});
```

## Security Checklist

### Authentication & Authorization
- [ ] Implement strong authentication (JWT, OAuth 2.0)
- [ ] Use HTTPS for all endpoints
- [ ] Hash passwords with bcrypt (salt rounds >= 10)
- [ ] Implement token expiration
- [ ] Add refresh token mechanism
- [ ] Verify user authorization for each request
- [ ] Implement role-based access control (RBAC)

### Input Validation
- [ ] Validate all user inputs
- [ ] Use parameterized queries or ORM
- [ ] Sanitize HTML content
- [ ] Validate file uploads
- [ ] Implement request schema validation
- [ ] Use allowlists, not blocklists

### Rate Limiting & DDoS Protection
- [ ] Implement rate limiting per user/IP
- [ ] Add stricter limits for auth endpoints
- [ ] Use Redis for distributed rate limiting
- [ ] Return proper rate limit headers
- [ ] Implement request throttling

### Data Protection
- [ ] Use HTTPS/TLS for all traffic
- [ ] Encrypt sensitive data at rest
- [ ] Don't store sensitive data in JWT
- [ ] Sanitize error messages
- [ ] Implement proper CORS configuration
- [ ] Use security headers (Helmet.js)

### Monitoring & Logging
- [ ] Log security events
- [ ] Monitor for suspicious activity
- [ ] Set up alerts for failed auth attempts
- [ ] Track API usage patterns
- [ ] Don't log sensitive data

## OWASP API Security Top 10

1. **Broken Object Level Authorization** - Always verify user can access resource
2. **Broken Authentication** - Implement strong authentication mechanisms
3. **Broken Object Property Level Authorization** - Validate which properties user can access
4. **Unrestricted Resource Consumption** - Implement rate limiting and quotas
5. **Broken Function Level Authorization** - Verify user role for each function
6. **Unrestricted Access to Sensitive Business Flows** - Protect critical workflows
7. **Server Side Request Forgery (SSRF)** - Validate and sanitize URLs
8. **Security Misconfiguration** - Use security best practices and headers
9. **Improper Inventory Management** - Document and secure all API endpoints
10. **Unsafe Consumption of APIs** - Validate data from third-party APIs
