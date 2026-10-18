/**
 * SvaraPrana (स्वरप्राण) — Native Desktop Application Runner
 * Cross-Platform Electron Process for Windows (.exe), macOS (.dmg/.app), and Linux (.AppImage/.deb)
 * SaarthiX Hackathon 2026 — Level 2 Implementation Suite
 */

const { app, BrowserWindow, Menu, session, ipcMain, shell } = require('electron');
const path = require('path');

let mainWindow = null;

function createMainWindow() {
  mainWindow = new BrowserWindow({
    width: 1440,
    height: 920,
    minWidth: 1024,
    minHeight: 720,
    title: 'SvaraPrana (स्वरप्राण) — Zero-Hardware Ambient Acoustic Care Bridge',
    backgroundColor: '#0B0F19',
    show: false,
    webPreferences: {
      preload: path.join(__dirname, 'electron', 'preload.cjs'),
      nodeIntegration: false,
      contextIsolation: true,
      enableRemoteModule: false,
      sandbox: true
    }
  });

  // Handle native audio/microphone permissions for DSP
  session.defaultSession.setPermissionCheckHandler((webContents, permission) => {
    if (permission === 'media') return true;
    return false;
  });

  session.defaultSession.setDevicePermissionHandler(() => true);

  // Load from local FastAPI backend or static single-file index.html directly
  const localBackendUrl = 'http://localhost:8000';
  mainWindow.loadURL(localBackendUrl).catch(() => {
    // Fallback: If Python FastAPI server is not currently running, load local static index.html directly
    mainWindow.loadFile(path.join(__dirname, 'index.html'));
  });

  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  // Open external links safely in system default browser
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    if (url.startsWith('http:') || url.startsWith('https:')) {
      shell.openExternal(url);
    }
    return { action: 'deny' };
  });

  setupApplicationMenu();
}

function setupApplicationMenu() {
  const isMac = process.platform === 'darwin';
  const template = [
    ...(isMac ? [{
      label: 'SvaraPrana',
      submenu: [
        { role: 'about' },
        { type: 'separator' },
        { role: 'services' },
        { type: 'separator' },
        { role: 'hide' },
        { role: 'hideOthers' },
        { role: 'unhide' },
        { type: 'separator' },
        { role: 'quit' }
      ]
    }] : []),
    {
      label: 'File',
      submenu: [
        {
          label: 'Emergency SOS Drill',
          accelerator: 'CmdOrCtrl+Shift+E',
          click: () => {
            if (mainWindow) {
              mainWindow.webContents.executeJavaScript("document.getElementById('btnTriggerSOSDrill').click();");
            }
          }
        },
        {
          label: 'Run Cryptographic Memory Purge Test',
          accelerator: 'CmdOrCtrl+Shift+P',
          click: () => {
            if (mainWindow) {
              mainWindow.webContents.executeJavaScript("document.getElementById('btnPrivacyShield').click();");
            }
          }
        },
        { type: 'separator' },
        isMac ? { role: 'close' } : { role: 'quit' }
      ]
    },
    {
      label: 'View',
      submenu: [
        { role: 'reload' },
        { role: 'forceReload' },
        { role: 'toggleDevTools' },
        { type: 'separator' },
        { role: 'resetZoom' },
        { role: 'zoomIn' },
        { role: 'zoomOut' },
        { type: 'separator' },
        { role: 'togglefullscreen' }
      ]
    },
    {
      label: 'Portals',
      submenu: [
        {
          label: 'Live Vitality DSP Bridge',
          accelerator: 'CmdOrCtrl+1',
          click: () => {
            if (mainWindow) {
              mainWindow.webContents.executeJavaScript("document.getElementById('sideTabVitality').click();");
            }
          }
        },
        {
          label: 'Adherence & Hesitation Engine',
          accelerator: 'CmdOrCtrl+2',
          click: () => {
            if (mainWindow) {
              mainWindow.webContents.executeJavaScript("document.getElementById('sideTabMedication').click();");
            }
          }
        },
        {
          label: 'Tiered Safety & SOS Relay',
          accelerator: 'CmdOrCtrl+3',
          click: () => {
            if (mainWindow) {
              mainWindow.webContents.executeJavaScript("document.getElementById('sideTabEscalation').click();");
            }
          }
        }
      ]
    },
    {
      label: 'Help',
      submenu: [
        {
          label: 'Documentation & Hackathon Proposal',
          click: () => {
            shell.openPath(path.join(__dirname, 'SvaraPrana_Hackathon_Proposal.pdf'));
          }
        }
      ]
    }
  ];

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

// App lifecycle management
app.whenReady().then(() => {
  createMainWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createMainWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
