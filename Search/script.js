// script.js
document.addEventListener("DOMContentLoaded", function() {
    // Function to update the current time in hours, minutes, and seconds
    function updateTime() {
        const now = new Date();
        const hours = String(now.getHours()).padStart(2, '0'); // Get hours
        const minutes = String(now.getMinutes()).padStart(2, '0'); // Get minutes
        const seconds = String(now.getSeconds()).padStart(2, '0'); // Get seconds

        // Update time display
        document.getElementById('currentTime').innerText = `${hours}:${minutes}:${seconds}`;
    }

    // Update the time immediately and set it to update every second
    updateTime();
    setInterval(updateTime, 1000); // Update time every second
});
