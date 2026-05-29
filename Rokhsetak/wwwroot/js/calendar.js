/* calendar.js
 * Initializes the FullCalendar v6 instance on the My Calendar page.
 *
 * Events are read from <script id="calendar-events-data" type="application/json">…</script>
 * embedded in the view. This is safer than interpolating JSON directly into a
 * runtime <script> block, and keeps all JavaScript out of the .cshtml file.
 *
 * Requires: FullCalendar v6 global build loaded before this script.
 */
(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {
        var calendarEl = document.getElementById('calendar');
        if (!calendarEl) return;
        if (typeof FullCalendar === 'undefined') {
            console.warn('Calendar: FullCalendar library not loaded.');
            return;
        }

        // ---- Load events from the JSON data island ----
        var events = [];
        var dataEl = document.getElementById('calendar-events-data');
        if (dataEl && dataEl.textContent) {
            try {
                events = JSON.parse(dataEl.textContent);
            } catch (e) {
                console.warn('Calendar: failed to parse events JSON.', e);
                events = [];
            }
        }

        // ---- Tag each event with a status class so CSS can theme it ----
        var KNOWN_STATUSES = ['confirmed', 'pending', 'completed', 'exam'];
        events = events.map(function (ev) {
            var status = (ev.extendedProps && ev.extendedProps.status) || ev.status || '';
            var key = String(status).toLowerCase();
            var cls = ev.classNames || [];
            if (!Array.isArray(cls)) cls = [cls];
            if (KNOWN_STATUSES.indexOf(key) !== -1) {
                cls.push('is-' + key);
            }
            ev.classNames = cls;
            return ev;
        });

        // ---- Build the calendar ----
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            headerToolbar: {
                left:   'prev,next today',
                center: 'title',
                right:  'dayGridMonth,timeGridWeek,listMonth'
            },
            events: events,
            eventDisplay: 'block',
            nowIndicator: true,
            height: 'auto',

            eventClick: function (info) {
                var props = info.event.extendedProps || {};

                var message = [
                    info.event.title,
                    'Status: ' + (props.status || '—'),
                    props.location ? ('Location: ' + props.location) : null
                ].filter(Boolean).join('\n');

                var url = props.url;

                if (url) {
                    if (confirm(message + '\n\nGo to details page?')) {
                        window.location.href = url;
                    }
                } else {
                    alert(message);
                }
            },

            eventDidMount: function (info) {
                var status = (info.event.extendedProps && info.event.extendedProps.status) || '';
                info.el.title = info.event.title + (status ? ' [' + status + ']' : '');
            }
        });

        calendar.render();
    });
})();
