
// Use native fetch (Node 18+)
const url = "https://vugyakqabzksrwvrxkof.supabase.co/rest/v1/";
const apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1Z3lha3FhYnprc3J3dnJ4a29mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk0MzE1MDQsImV4cCI6MjA4NTAwNzUwNH0.gydeQ9jiiBYQOjXf4FozDn1Acjv9ofxlpqnEzsojqtc";
const options = {
    method: 'GET',
    headers: {
        'apikey': apiKey,
        'Authorization': `Bearer ${apiKey}`
    }
};

console.log(`Testing connection to ${url}...`);

try {
    const res = await fetch(url + "categories?select=count", options);
    console.log(`Status: ${res.status} ${res.statusText}`);
    const text = await res.text();
    console.log("Response:", text.substring(0, 100)); // First 100 chars
} catch (error) {
    console.error("Connection failed:", error);
}
