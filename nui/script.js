/*window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'position') {
        document.getElementById('streetname-output').textContent    = data.streetname1
        document.getElementById('heading-output').textContent       = data.heading
        document.getElementById('zone-output').textContent          = data.zone2
    }
});
*/

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type === 'position') {
        document.getElementById('streetname-output').textContent = data.streetname1;
        document.getElementById('heading-output').textContent = data.heading;
        document.getElementById('zone-output').textContent = data.zone2;
    } else if (data.type === 'toggle_ui') {
        if (data.show) {
            $(".location").fadeIn(500);
        } else {
            $(".location").fadeOut(500);
        }
    }
});