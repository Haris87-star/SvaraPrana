/**
 * SvaraPrana - Electron Preload Script
 * Exposes secure platform metadata to frontend without compromising security
 */

const { contextBridge } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  platform: process.platform,
  version: process.versions.electron,
  isDesktop: true
});
