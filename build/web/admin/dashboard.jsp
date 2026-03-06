<%-- 
    Document   : dashboard
    Author     : kiru
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort · Admin Dashboard</title>
    <!-- Tailwind via CDN + Inter font + same subtle style -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', system-ui, sans-serif; }
        .card-dash { transition: all 0.2s; }
        .card-dash:hover { transform: translateY(-2px); box-shadow: 0 16px 24px -8px rgba(2, 116, 140, 0.12); }
        .stat-glow { text-shadow: 0 2px 5px rgba(2, 132, 168, 0.2); }
    </style>
</head>
<body class="bg-[#f0f7fa] text-[#1e3c5c] antialiased flex">

    <!-- Include Sidebar -->
    <jsp:include page="/component/sidebar.jsp" />
    
    <!-- Include notification.jsp -->
    <jsp:include page="/component/notification.jsp" />

    <!-- ===== MAIN DASHBOARD (right side) ===== -->
    <main class="flex-1 overflow-y-auto">

        <!-- top bar (simple) with same beachy vibe -->
        <header class="bg-white/70 backdrop-blur-sm border-b border-[#b5e5e0] py-4 px-8 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center gap-2 text-[#1e3c5c]">
                <span class="text-xl">📋</span>
                <span class="font-semibold">Dashboard / overview</span>
            </div>
        
        </header>

        <!-- dashboard content (right side) with same ocean palette -->
        <div class="p-6 md:p-8 space-y-8">

            <!-- WELCOME + STATS (social proof style numbers) -->
            <div>
                <h2 class="text-2xl md:text-3xl font-bold text-[#1e3c5c]">Welcome back, Tharushi 👋</h2>
                <p class="text-[#3a5a78] text-base mt-1">Here's what's happening at Ocean View Resort · Galle</p>
            </div>

            <!-- stat cards (matching the 4-column stats from index) -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
                <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] p-6 card-dash flex flex-col">
                    <span class="text-[#0284a8] text-sm font-semibold uppercase tracking-wide">monthly guests</span>
                    <span class="text-4xl font-black text-[#1e3c5c] mt-1 stat-glow">412</span>
                    <span class="text-sm text-[#3a5a78] mt-2 flex items-center gap-1">⬆️ 8% vs last month</span>
                </div>
                <div class="bg-white rounded-2xl shadow-md border border-[#f8e4c3] p-6 card-dash">
                    <span class="text-[#d4a373] text-sm font-semibold uppercase">rooms occupied</span>
                    <span class="text-4xl font-black text-[#1e3c5c] mt-1">67 <span class="text-lg font-normal text-[#3a5a78]">/82</span></span>
                    <span class="text-sm text-[#3a5a78] mt-2">⬆️ 82% occupancy</span>
                </div>
                <div class="bg-white rounded-2xl shadow-md border border-[#9ac9c2] p-6 card-dash">
                    <span class="text-[#03738C] text-sm font-semibold uppercase">revenue (month)</span>
                    <span class="text-4xl font-black text-[#1e3c5c] mt-1">$48.6k</span>
                    <span class="text-sm text-[#3a5a78] mt-2">⬆️ 12% vs May</span>
                </div>
                <div class="bg-white rounded-2xl shadow-md border border-[#b5e5e0] p-6 card-dash">
                    <span class="text-[#0284a8] text-sm font-semibold uppercase">new bookings</span>
                    <span class="text-4xl font-black text-[#1e3c5c] mt-1">24</span>
                    <span class="text-sm text-[#3a5a78] mt-2">last 24h · 3 pending</span>
                </div>
            </div>

            <!-- CHARTS / GRAPH placeholder + recent activity (split) -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-7">
                <!-- left: occupancy chart mockup (larger) -->
                <div class="lg:col-span-2 bg-white rounded-3xl shadow-md border border-[#b5e5e0] p-6">
                    <div class="flex justify-between items-center">
                        <h3 class="font-bold text-xl text-[#1e3c5c] flex items-center gap-2"><span class="text-[#0284a8]">📈</span> Occupancy trend (last 7 days)</h3>
                        <span class="text-sm text-[#0284a8] bg-[#b5e5e0]/30 px-3 py-1 rounded-full">Jun 2025</span>
                    </div>
                    <!-- simple bar graph simulation with ocean colors -->
                    <div class="mt-7 flex items-end h-36 gap-3">
                        <div class="flex-1 flex flex-col items-center gap-1"><div class="w-full bg-[#b5e5e0] rounded-t-lg h-16"></div><span class="text-xs text-[#3a5a78]">Mon</span></div>
                        <div class="flex-1 flex flex-col items-center gap-1"><div class="w-full bg-[#9ac9c2] rounded-t-lg h-24"></div><span class="text-xs">Tue</span></div>
                        <div class="flex-1 flex flex-col items-center gap-1"><div class="w-full bg-[#0284a8] rounded-t-lg h-28"></div><span class="text-xs">Wed</span></div>
                        <div class="flex-1 flex flex-col items-center gap-1"><div class="w-full bg-[#03738C] rounded-t-lg h-32"></div><span class="text-xs text-white font-semibold drop-shadow">Thu</span></div>
                        <div class="flex-1 flex flex-col items-center gap-1"><div class="w-full bg-[#0284a8] rounded-t-lg h-20"></div><span class="text-xs">Fri</span></div>
                        <div class="flex-1 flex flex-col items-center gap-1"><div class="w-full bg-[#9ac9c2] rounded-t-lg h-24"></div><span class="text-xs">Sat</span></div>
                        <div class="flex-1 flex flex-col items-center gap-1"><div class="w-full bg-[#b5e5e0] rounded-t-lg h-18"></div><span class="text-xs">Sun</span></div>
                    </div>
                    <div class="flex justify-between mt-4 text-sm text-[#3a5a78] border-t border-[#cdeae5] pt-4">
                        <span>📊 avg. occupancy 78%</span>
                        <span class="text-[#0284a8]">+6% vs last week</span>
                    </div>
                </div>

                <!-- right: recent guests / quick actions -->
                <div class="bg-white rounded-3xl shadow-md border border-[#f8e4c3] p-6">
                    <h3 class="font-bold text-xl text-[#1e3c5c] flex items-center gap-2"><span class="text-[#d4a373]">⏳</span> Recent check-ins</h3>
                    <ul class="mt-5 space-y-4">
                        <li class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-full bg-[#f8e4c3] flex items-center justify-center text-[#d4a373]">SP</div>
                            <div><p class="font-medium">Sam Perera</p><p class="text-xs text-[#3a5a78]">Deluxe Ocean · room 218</p></div>
                            <span class="ml-auto text-xs bg-[#b5e5e0] text-[#03738C] px-2 py-1 rounded-full">just now</span>
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-full bg-[#b5e5e0] flex items-center justify-center text-[#0284a8]">AK</div>
                            <div><p class="font-medium">Amara Kumar</p><p class="text-xs text-[#3a5a78]">Beachfront Suite · 105</p></div>
                            <span class="ml-auto text-xs bg-[#f8e4c3] text-[#d4a373] px-2 py-1 rounded-full">1h ago</span>
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-full bg-[#9ac9c2] flex items-center justify-center text-[#03738C]">DW</div>
                            <div><p class="font-medium">Dilan Weer</p><p class="text-xs text-[#3a5a78]">Garden View · 309</p></div>
                            <span class="ml-auto text-xs bg-[#b5e5e0] text-[#03738C] px-2 py-1 rounded-full">2h ago</span>
                        </li>
                        <li class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-full bg-[#f8e4c3] flex items-center justify-center text-[#d4a373]">NJ</div>
                            <div><p class="font-medium">Nadia J.</p><p class="text-xs text-[#3a5a78]">Deluxe Ocean · 222</p></div>
                            <span class="ml-auto text-xs bg-[#f8e4c3] text-[#d4a373] px-2 py-1 rounded-full">5h ago</span>
                        </li>
                    </ul>
                    <a href="#" class="inline-block mt-6 text-[#0284a8] font-medium text-sm hover:underline">view all guests →</a>
                </div>
            </div>

            <!-- TABLE / recent bookings (like room preview but data) -->
            <div class="bg-white rounded-3xl shadow-lg border border-[#9ac9c2] overflow-hidden">
                <div class="px-7 py-5 bg-gradient-to-r from-[#f0f7fa] to-white border-b border-[#b5e5e0] flex justify-between items-center">
                    <h3 class="font-bold text-xl text-[#1e3c5c]">📋 Latest bookings</h3>
                    <span class="bg-[#0284a8] text-white text-xs px-4 py-2 rounded-full">12 new today</span>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-sm">
                        <thead class="bg-[#b5e5e0]/20 text-[#03738C] text-xs font-semibold uppercase tracking-wider">
                            <tr>
                                <th class="px-6 py-4 text-left">Guest</th>
                                <th class="px-6 py-4 text-left">Room</th>
                                <th class="px-6 py-4 text-left">Check‑in</th>
                                <th class="px-6 py-4 text-left">Check‑out</th>
                                <th class="px-6 py-4 text-left">Status</th>
                                <th class="px-6 py-4 text-left">Amount</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-[#cdeae5]">
                            <tr class="hover:bg-[#f0fbfe]">
                                <td class="px-6 py-4 font-medium">Ravi De Silva</td>
                                <td class="px-6 py-4">Beachfront Suite #105</td>
                                <td class="px-6 py-4">2025-06-12</td>
                                <td class="px-6 py-4">2025-06-18</td>
                                <td class="px-6 py-4"><span class="bg-[#b5e5e0] text-[#03738C] px-3 py-1 rounded-full text-xs">confirmed</span></td>
                                <td class="px-6 py-4 font-medium">$1,494</td>
                            </tr>
                            <tr class="hover:bg-[#f0fbfe]">
                                <td class="px-6 py-4 font-medium">Emily Koch</td>
                                <td class="px-6 py-4">Deluxe Ocean #218</td>
                                <td class="px-6 py-4">2025-06-13</td>
                                <td class="px-6 py-4">2025-06-15</td>
                                <td class="px-6 py-4"><span class="bg-[#f8e4c3] text-[#d4a373] px-3 py-1 rounded-full text-xs">checked in</span></td>
                                <td class="px-6 py-4">$378</td>
                            </tr>
                            <tr class="hover:bg-[#f0fbfe]">
                                <td class="px-6 py-4 font-medium">Mohamed Hisham</td>
                                <td class="px-6 py-4">Garden View #309</td>
                                <td class="px-6 py-4">2025-06-14</td>
                                <td class="px-6 py-4">2025-06-17</td>
                                <td class="px-6 py-4"><span class="bg-[#9ac9c2] text-[#03738C] px-3 py-1 rounded-full text-xs">pending</span></td>
                                <td class="px-6 py-4">$417</td>
                            </tr>
                            <tr class="hover:bg-[#f0fbfe]">
                                <td class="px-6 py-4 font-medium">Nimali Perera</td>
                                <td class="px-6 py-4">Deluxe Ocean #201</td>
                                <td class="px-6 py-4">2025-06-11</td>
                                <td class="px-6 py-4">2025-06-16</td>
                                <td class="px-6 py-4"><span class="bg-[#b5e5e0] text-[#03738C] px-3 py-1 rounded-full text-xs">confirmed</span></td>
                                <td class="px-6 py-4">$945</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="p-5 bg-[#f8fafc] border-t border-[#b5e5e0] text-right">
                    <a href="#" class="text-[#0284a8] font-medium inline-flex items-center gap-1">view all bookings →</a>
                </div>
            </div>

            <!-- small extra row: quick actions / notes (like testimonial style but for tasks) -->
            <div class="bg-gradient-to-r from-[#1e3c5c] to-[#03738C] text-white p-7 rounded-3xl shadow-lg flex flex-wrap items-center justify-between">
                <div class="flex items-center gap-4">
                    <span class="text-5xl">📌</span>
                    <div>
                        <p class="text-xl font-semibold">You have 3 unread messages from guests</p>
                        <p class="text-[#b5e5e0] text-sm">including a special request for room 105</p>
                    </div>
                </div>
                <a href="#" class="bg-[#f8e4c3] text-[#1e3c5c] px-7 py-3 rounded-full font-medium hover:bg-[#e6d1ad] transition shadow-md mt-4 sm:mt-0">view messages</a>
            </div>
        </div>

        <!-- simple footer (like in index but compact) -->
        <footer class="border-t border-[#b5e5e0] bg-white/60 py-4 px-8 text-sm text-[#3a5a78] flex justify-between">
            <span>© 2025 Ocean View Resort · Galle</span>
            <span class="flex gap-4">🌊 v2.0 admin · 2 active staff</span>
        </footer>
    </main>
</body>
</html>