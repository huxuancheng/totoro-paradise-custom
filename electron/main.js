const { app, BrowserWindow } = require('electron')
const path = require('path')
const { spawn } = require('child_process')

let mainWindow
let devServer

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1280,
    height: 800,
    minWidth: 800,
    minHeight: 600,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      enableRemoteModule: false
    },
    title: 'Totoro-paradise 跑步打卡工具'
  })

  // 检查是否在开发模式
  if (process.env.NODE_ENV === 'development') {
    // 开发模式: 启动 dev server
    mainWindow.loadURL('http://localhost:3000')
    
    // 打开开发者工具
    mainWindow.webContents.openDevTools()
  } else {
    // 生产模式: 加载构建后的文件
    mainWindow.loadFile(path.join(__dirname, '../.output/public/index.html'))
  }

  mainWindow.on('closed', () => {
    mainWindow = null
  })

  mainWindow.webContents.on('new-window', (event, url) => {
    event.preventDefault()
    require('electron').shell.openExternal(url)
  })
}

function startDevServer() {
  return new Promise((resolve, reject) => {
    const serverPath = path.join(__dirname, '../node_modules/.bin/nuxt')
    
    devServer = spawn('node', [serverPath, 'dev'], {
      cwd: path.join(__dirname, '..'),
      stdio: 'inherit',
      shell: true
    })

    devServer.on('error', reject)
    devServer.on('exit', (code) => {
      if (code !== 0) {
        reject(new Error(`Dev server exited with code ${code}`))
      }
    })

    // 等待服务器启动
    setTimeout(() => {
      resolve()
    }, 5000)
  })
}

app.whenReady().then(async () => {
  if (process.env.NODE_ENV === 'development') {
    try {
      console.log('Starting dev server...')
      await startDevServer()
      console.log('Dev server started')
    } catch (error) {
      console.error('Failed to start dev server:', error)
      app.quit()
      return
    }
  }
  
  createWindow()

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow()
    }
  })
})

app.on('window-all-closed', () => {
  // 清理 dev server
  if (devServer) {
    devServer.kill()
  }
  
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('before-quit', () => {
  if (devServer) {
    devServer.kill()
  }
})
