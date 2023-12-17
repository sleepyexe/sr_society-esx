ShSociety = {}

ShSociety.Locations = {
    {
        name = "Boss Menu Polisi",
        coords = vector3(358.9968, -1590.6594, 31.0515),
        size = vector3(1.5, 1.5, 2.0),
        rotation = 224.0760,
        job = 'police'
    },
    {
        name = "Boss Menu EMS",
        coords = vector3(-504.4485, -298.5960, 42.3207),
        size = vector3(1.5, 1.5, 2.0),
        rotation = 228.3426,
        job = 'ambulance'
    },
    {
        job = 'mechanic',
        coords = vector3(31.9873, 6518.2612, 35.6397),
        size = vector3(1.5, 1.5, 2.0),
        rotation = 29.6398
    },
    {
        name = "Boss Menu Biker",
        coords = vec3(472.11, -1310.68, 29.21),
        size = vec3(2, 2, 2),
        rotation = 45,
        job = 'biker'
    },
    {
        name = "Boss Menu Mafia",
        coords = vector3(-1528.6617, 150.2658, 60.7980),
        size = vector3(1.5, 1.5, 2.0),
        rotation = 150.9060,
        job = 'mafia'
    },
    {
        name = "Boss Menu Mafia2",
        coords = vector3(518.4591, -2757.7576, 6.6410),
        size = vector3(1.5, 1.5, 2.0),
        rotaiton =  253.9954,
        job = 'mafia2'
    },
    {
        name = "Boss Menu biker",
        coords = vector3(1993.6875, 3044.9788, 50.5150),
        size = vector3(1.5, 1.5, 2.0),
        rotation = 239.4998,
        job = 'biker'
    },
    {
        name = "Boss Menu biker2",
        coords = vector3(989.5347, -135.8656, 74.0614),
        size = vector3(1.5, 1.5, 2.0),
        rotation =  74.8940,
        job = 'biker2'
    },
    {
        coords = vector3(-1876.7579, 2060.1030, 146.3201),
        size = vector3(1.5, 1.5, 2.0),
        rotation =  73.6969,
        job = 'yakuza'
    },
    {
        job = 'cartel2',
        coords = vector3(-1796.4075, 450.5680, 128.5076),
        size = vector3(1.5, 1.5, 2.0),
        rotation =  216.4869
    },
    {
        job = 'cartel',
        coords = vector3(1378.8933, -2090.4541, 52.6089),
        size = vector3(1.5, 1.5, 2.0),
        rotation =  357.0388,
    },
    {
        job = 'gang',
        coords = vector3(352.1753, -2054.3918, 22.2453),
        size = vector3(1.5, 1.5, 2.0),
        rotation =  122.2542
    },
    {
        job = 'gang2',
        coords = vector3(-239.4302, -1515.8481, 33.3802), 
        size = vector3(1.5, 1.5, 2.0),
        rotation = 136.6884
    },
    {
        job = 'bahamas',
        coords = vector3(96.9913, -1303.5287, 29.2555), 
        size = vector3(1.5, 1.5, 2.0),
        rotation = 17.9184
    },
    {
        name = "Boss Menu Pedagang",
        coords = vector3(-2070.6719, -454.6166, 12.3740), 
        size = vector3(1.5, 1.5, 2.0),
        rotation = 145.2580,
        job = 'pedagang'
    },
}


ShSociety.Access = {
    ['pedagang'] = {
        withdraw = 4,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['police']  = {
        withdraw = 16,
        deposit = 16,
        hire = 16,
        setRank = 16,
        bonus = 16,
    },
    ['ambulance']  = {
        withdraw = 12,
        deposit = 12,
        hire = 12,
        setRank = 12,
        bonus = 12,
    },
    ['mechanic']  = {
        withdraw = 4,
        deposit = 4,
        hire = 4,
        setRank = 4,
        bonus = 4,
    },
    ['mafia2'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['mafia'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['biker'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['biker2'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['yakuza'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['cartel'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['cartel2'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['gang'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['gang2'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
    ['bahamas'] = {
        withdraw = 3,
        deposit = 3,
        hire = 3,
        setRank = 3,
        bonus = 3,
    },
}