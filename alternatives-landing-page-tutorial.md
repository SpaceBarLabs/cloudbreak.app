# Tutorial: Creating an Alternative RSS Reader Landing Page

## Overview
We're building a minimalist landing page to gauge interest in Tiny Tiny RSS hosting. This page will:
- Live under /alternatives/tiny-tiny-rss/
- Use existing feature request form for waitlist
- Track analytics for interest measurement
- Maintain consistent branding

## Technical Components

### 1. Directory Structure
```
alternatives/
  tiny-tiny-rss/
    index.html      # Landing page
    screenshot.webp # (Optional) Screenshot
```

### 2. Page Structure
The index.html will follow our established patterns:
- Jekyll front matter for SEO
- Structured data for search engines
- Analytics event tracking
- Bulma CSS classes

### 3. Analytics Implementation
We'll track:
- Page views
- Waitlist form clicks
- Time on page
- Scroll depth (optional)

### 4. Implementation Steps

1. Create directory structure:
   ```bash
   mkdir -p alternatives/tiny-tiny-rss
   ```

2. Create index.html with:
   - SEO meta tags
   - Open Graph tags
   - Schema.org markup
   - Basic content section
   - Analytics tracking script

3. Add to sitemap.xml:
   - New URL entry
   - Last modified date
   - Change frequency
   - Priority setting

4. Update robots.txt:
   - Ensure path is crawlable
   - Set appropriate directives

### 5. Testing
- Validate HTML structure
- Check analytics events fire
- Test responsive design
- Verify form links work
- Check SEO meta tags

## Code Examples

### Analytics Event
```javascript
document.querySelector('a[href*="docs.google.com/forms"]').addEventListener('click', function() {
  gtag('event', 'waitlist_signup', {
    'service': 'tiny_tiny_rss',
    'location': 'alternatives_page'
  });
});
```

### Schema.org Markup
```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Tiny Tiny RSS Hosting",
  "description": "Join the waitlist for our upcoming Tiny Tiny RSS hosting service."
}
```

## Notes
- Keep design minimal but professional
- Focus on single call-to-action (waitlist signup)
- Use consistent branding with main site
- Track analytics for decision making

## Future Considerations
- FAQ section if demand grows
- Pricing structure planning
- Feature comparison table
- Integration with main navigation