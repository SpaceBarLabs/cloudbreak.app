# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CloudBreak.app is a static website for a privacy-focused RSS hosting service that offers two products:
- FreshRSS hosting
- Feedbin Mini hosting

The site is built with Jekyll (via GitHub Pages) and focuses on privacy, data portability, and user control.

## Development Environment

### Setup

```bash
# Install dependencies (Ruby and Bundler required)
bundle install
```

### Development Commands

```bash
# Run local development server
bundle exec jekyll serve

# Run development server with development config (including dev GA ID)
./dev.sh
# or manually:
bundle exec jekyll serve --config _config.yml,_config_development.yml --host 0.0.0.0 --port 4000

# Build site
bundle exec jekyll build
```

## Project Structure

- Main site pages in root directory (index.html)
- Product-specific pages in subdirectories:
  - `/freshrss/` - FreshRSS hosting service
  - `/feedbin-mini/` - Feedbin Mini hosting service
- Each product has a FAQ section:
  - `/freshrss/faq/`
  - `/feedbin-mini/faq/`

## Deployment

The site uses conventional GitHub Pages deployment - when code is pushed to the main branch, GitHub automatically builds and deploys the site. The custom domain is configured via the CNAME file.

Note: A local development environment that perfectly matches the GitHub Pages build environment is not yet established.

## SEO and Analytics

The site uses:
- Structured data (JSON-LD) for SEO
- Google Analytics 4 with Consent Mode for privacy-respecting analytics
- Comprehensive meta tags, Open Graph, and Twitter Cards
- A detailed sitemap.xml

When modifying the site, maintain the privacy-focused approach and ensure all tracking is consent-based.

## Current Development Initiatives

1. SEO improvements (detailed in seo-plan.md)
2. Google Analytics enhancements with privacy focus (detailed in google-analytics-plan.md)