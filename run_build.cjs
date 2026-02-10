const { execSync } = require('child_process');

try {
    console.log('Running npm install...');
    execSync('npm install', { stdio: 'inherit', shell: 'cmd.exe' });
    console.log('Running npm run build...');
    execSync('npm run build', { stdio: 'inherit', shell: 'cmd.exe' });
} catch (error) {
    console.error('Build failed:', error);
    process.exit(1);
}
