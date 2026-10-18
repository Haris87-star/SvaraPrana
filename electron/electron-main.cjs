/**
 * SvaraPrana - Electron Desktop Main Process
 * Cross-platform desktop application runner for Windows (.exe) and macOS (.dmg / .app)
 */

const { app, BrowserWindow, session } = require('electron');
const path = require('path');

function createWindow() {
  const win = new BrowserWindow({
    width: 1400,
    height: 920,
    minWidth: 1024,
    minHeight: 700,
    title: 'SvaraPrana स्वरप्राण — Ambient Acoustic Care Bridge',
    backgroundColor: '#090D16',
    titleBarStyle: 'hiddenInset',
    autoHideMenuBar: false,
    icon: path.join(__dirname, '../public/assets/icons/icon-512.svg'),
    webPreferences: {
      preload: path.join(__dirname, 'preload.cjs'),
      contextIsolation: true,
      nodeIntegration: false
    }
  });

  // Automatically handle microphone permissions for DSP
  session.defaultSession.setPermissionCheckHandler((webContents, permission) => {
    if (permission === 'media') return true;
    return false;
  });

  session.defaultSession.setDevicePermissionHandler(() => true);

  // Load from local FastAPI backend or static files
  const serverUrl = 'http://localhost:8000';
  win.loadURL(serverUrl).catch(() => {
    // If backend not running, load local static html directly
    win.loadFile(path.join(__dirname, '../public/index.html'));
  });

  return win;
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
