


fun void show (string arr[]) {
    for (0 => int i;i < arr.cap();i++) {
        <<<arr[i]>>>;
    }
    <<<"end">>>;
}



fun void show (int arr[]) {
    for (0 => int i;i < arr.cap();i++) {
        <<<arr[i]>>>;
    }
    <<<"end">>>;
}



fun void show (float arr[]) {
    for (0 => int i;i < arr.cap();i++) {
        <<<arr[i]>>>;
    }
    <<<"end">>>;
}



fun void show_music(float music[][]) {
    for (0 => int i;i < music.cap();i++) {
        for (0 => int j;j < music[0].cap();j++) {
            <<<music[i][j]>>>;
        }
        <<<"end">>>;
    }
}



fun string[] split(string str) {
    
    string res[0];
    
    // the very hacked StringTokenizer

    // make one
    StringTokenizer tok;

    // set the string
    tok.set( str );

    // iterate
    while ( tok.more() ) {
        // dybamic array
        res << tok.next();
    }

    return res;
}



fun float make_seed (int base) {
    int seed;
    float res;
    Std.rand2(0, 11) => seed;
    seed/1.0 => res;
    base/1.0 +=> res;
    
    return res;
}



fun float[] pitches_processor (string tmp[]) {
    
    float pitches[0];
    float note;
    
    for (0 => int i;i < tmp.cap();i++) {

        ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"] @=> string notes[];
        for (0 => int j;j < notes.cap();j++) {
            if (notes[j].upper() == tmp[i].upper()) {
                j/1.0 => note;
                pitches << note;
                break;
            }
        }
    }
    
    return pitches;
}



fun float[] make_melody (float seed, int leng, float pitches[]) {
    float melody[0];
    
    for (0 => int i;i < leng;++i) {
        Std.rand2(0, pitches.cap()-1) => int choose;
        melody << pitches[choose] + seed;
    }
    
    return melody;
}



fun float LCM (float a, float b) {
    
    float num, den, rem, gcd, lcm;
    
    if (a == 1.0/3) {
        1 => a;    
    } else if (b == 1.0/3) {
        1 => b;
    }
    
    if (a > b) {
        a => num;
        b => den;
    } else {
        b => num;
        a => den;
    }
    num % den => rem;
    
    while (rem != 0) {
        den => num;
        rem => den;
        num % den => rem;
    }
    
    den => gcd;
    a*b/gcd => lcm;
    
    return lcm;
    
}



fun float find_LCM (float sth[]) {
    
    float lcm;
    //<<<"sth:", sth[0]>>>;
    if (sth.cap() == 0) {
        return 1.0; 
    } else if(sth.cap() == 1) {
        return sth[0]; 
    }
    
    sth[0] => float a;
    sth[1] => float b;
    
    LCM(a, b) => lcm;
    for (2 => int i;i < sth.cap();i++) {
        LCM(lcm, sth[i]) => lcm;
    }
    
    return lcm;
}



fun float[] meters_processor(string posibilities) {
    float meter;
    float meters[0];
    
    split(posibilities) @=> string tmp[];
    for (0 => int i;i < tmp.cap();++i) {
        if (tmp[i].find('/')+1) {
            1/tmp[i].substring(1).toFloat() => meter;
        } else {
            tmp[i].toFloat() => meter;
        }
        
        meters << meter;
    }
    
    return meters;
}



fun int chk_overload(float rest_atoms, float atom_meter, float choose) {
    choose/atom_meter => float choose_atoms;
    if (choose_atoms < 1) {
        1.0 => choose_atoms;
    }
    // <<<"#########################">>>;
    // <<<"choose", choose>>>;
    // <<<"atom_meter", atom_meter>>>;
    // <<<"choose_atoms", choose_atoms>>>;
    // <<<"rest_atoms", rest_atoms>>>;
    rest_atoms - choose_atoms => float final_rest_atoms;
    // <<<"choose_atoms", choose_atoms>>>;
    // <<<"final_rest_atoms", final_rest_atoms>>>;
    if (choose_atoms > final_rest_atoms) {
        if (final_rest_atoms == 0.0) {
            return 0;    
        }
        return 1;
    } else {
        return 0;
    }
}



fun float[] make_rhythm (float _1_meter, float total_meters, float meters[]) {
    
    float rhythm[0];
    float atom_meter;
    float tmp[0];    

    for (0 => int i;i < meters.cap();i++) {
        if (meters[i] < 1.0) {
            tmp << meters[i];
        } 
    }

    //show(tmp);
    find_LCM(tmp) => atom_meter;
    //<<<"find_LCM(tmp)", atom_meter>>>;
    total_meters / atom_meter => float atoms_num;
    //<<<"atoms_num", atoms_num>>>;
    meters.cap() => int choice_num;
    
    int choose;
    for (0 => int i;i < atoms_num;i++) {
        //0 => int cnt;
        Std.rand2(0, choice_num-1) => choose;
        while (chk_overload(atoms_num-i, atom_meter, meters[choose])) {
            Std.rand2(0, choice_num-1) => choose;
            //cnt ++;
            //if (cnt>10) {break;}
        }
        
        if (meters[choose] < 1.0) {
            atom_meter/meters[choose] => float times;
            for (0 => int j;j < times;j++) {
                rhythm << meters[choose];
            }
        } else {
            (meters[choose]/atom_meter - 1) $ int => int skip; 
            skip +=> i;
            rhythm << meters[choose];
        }
    }
    
    return rhythm;
}



fun void show_time(float music[][]) {
    show_music(music);
    <<<cal_meteres(music)>>>;
    
    1 => int gain;
    music[0] @=> float melody[];
    music[1] @=> float rhythm[];
    
    // init clarinet
    Clarinet clair => JCRev r => dac;
    gain => r.gain; 
    .1 => r.mix;
    
    clair.clear( 1.0 );
    0.338145+0.2 => clair.reed;
    0.077120+0.07 => clair.noiseGain;
    5.801325+5 => clair.vibratoFreq; 
    0.236030+-0.2 => clair.vibratoGain; 
    0.039827+3 => clair.pressure; 
    
    
    for (0 => int i;i < melody.cap();++i) {
        Std.mtof(melody[i]) => float freq;
        freq => clair.freq;
        clair.clear( 1.0 );
        .6 => clair.noteOn;

        
        rhythm[i]::second => now;
        
    }
    r =< dac;
    
    /*
    reed stiffness: 0.338145 
    noise gain: 0.077120 
    vibrato freq: 5.801325 
    vibrato gain: 0.236030 
    breath pressure: 0.039827 
    */
}



fun float[] rhythm_generator(string posibilities, float _1_meter, float body_meters) {
    meters_processor(posibilities) @=> float meters[];
    make_rhythm(_1_meter, body_meters, meters) @=> float rhythm[];

    return rhythm;
}



fun float[] melody_generator(string payload, float seed, int leng) {
    split(payload) @=> string tmp[];
    pitches_processor(tmp) @=> float pitches[];
    make_melody(seed, leng, pitches) @=> float melody[];
    
    return melody;
}



fun float[] array_cuter(float arr[], int num) {
    
    float res[0];
    if (num > arr.cap() || -num > arr.cap()) {
        <<<"error:array_cuter()">>>;
        return arr;
    }
    if (num > 0) {
        for (0 => int i;i < num;i++) {
            res << arr[i];
        }
    } else if (num < 0) {
        -num => num;
        for (arr.cap()-1 => int i;i >= arr.cap()-num;--i) {
            res << arr[i];
        }
    } else {
        arr @=> res;
    }
    
    return res;
}



fun int chk_music(float music[][]) {
    if (music[0].cap() != music[1].cap()) {
        <<<"illegal music format">>>;
        <<<"melody length:", music[0].cap()>>>;
        <<<"rhythm length:", music[1].cap()>>>;
        
        show(music[0]);
        show(music[1]);
        
        return 1;
    } else {
        return 0;
    }

}



fun float[][] mix_it(float melody[], float rhythm[]) {
    if (chk_music([melody, rhythm])) {
        int shortest;
        float tmp[0];
        if (melody.cap() > rhythm.cap()) {
            rhythm.cap() => shortest;
            return [array_cuter(melody, shortest), rhythm];
        } else {
            melody.cap() => shortest;
            return [melody, array_cuter(rhythm, shortest)];
        }
    } else {
        return [melody, rhythm];
    }
}



fun float[][] append_music(float a_music[][], float b_music[][]) {
    for (0 => int i;i < b_music[0].cap();i++) {
        for (0 => int j;j < b_music.cap();j++) {
            a_music[j] << b_music[j][i];
        }
    }
    
    return a_music;
}



fun int name2code(string name) {
    name.upper() => name;    
    name.charAt(0) => int ascii;
    ascii - 65 => int code;
    
    return code;
}



fun float[][] make_music(string r_posibilities, float r_1_meter, float r_total_meters, string m_payload, float m_seed) {
    
    // rhythm
    rhythm_generator(r_posibilities, r_1_meter, r_total_meters) @=> float rhythm[];
    rhythm.cap() => int leng;
        

    // melody
    melody_generator(m_payload, m_seed, leng) @=> float melody[];
    
    
    // mix_it
    mix_it(melody, rhythm) @=> float music[][];
    
    return music;

}



fun float[] just_make_melody(string payload, float seed, int leng) {
    float melody[0];
    split(payload) @=> string tmp[];
    pitches_processor(tmp) @=> float pitches[];
    for (0 => int i;i < pitches.cap();i++) {
        melody << pitches[i] + seed;
    }
    
    return melody;
}



fun float cal_meteres(float music[][]) {
    0 => float sum;
    for (0 => int i;i<music[0].cap();i++) {
        music[1][i] +=> sum;
    }
    
    return sum;
}



fun string get_name_from_file(string fname) {
    FileIO fio;

    // open a file
    fio.open(fname, FileIO.READ);

    // ensure it's ok
    if(!fio.good()) {
        cherr <= "can't open file: " <= fname <= " for reading..." <= IO.newline();
        me.exit();
    }

    fio.readLine() => string name;
    
    return name;

}



fun float[] melody_script(int payload[], float seed) {
    float res[0];
    for (0 => int i;i < payload.cap();i++) {
        //<<<"seed", seed>>>;
        //<<<"payload[i]", payload[i]>>>;
        //<<<"res", seed + payload[i]>>>;
        res << seed + payload[i];
    }
    
    return res;
}



fun int random(int a, int b) {
    return Std.rand2(a, b);
}



fun void wtf(string name) {
    // init
    1 => float _1_meter;
    10 => float total_meters;
    total_meters % 4 => float tail_meters;
    total_meters - tail_meters => float body_meters;   
   
    60 => int base;
    make_seed(base) => float seed;
    <<<"seed:", seed>>>; 
    
    string payload;
    string posibilities;
    int leng;
    float music[][];
    float tail_music[][];
    float head_music[][];
    
    
    name2code(name) => int code;
    
    [2, 5, 6, 8, 11, 13, 18, 9, 10, 23] @=> int whitelist[];
    1 => int flag;
    for (0 => int i;i < whitelist.cap();++i) {
        if (code == whitelist[i]) {
            0 => flag;
            break;
        }
    }
    
    if (flag) {
        random(0, whitelist.cap()-1) => int idx;
        whitelist[idx] => code;
    }
    
    <<<"code:", code>>>;
    
    if (code == 0) {
        // A
        
        
    } else if (code == 1) {
        // B
        
    } else if (code == 2) {
        // C        

        
        "2 /2 /4" => posibilities;
        
        0 => leng;
        float rhythm[];
        float melody[];
        while (leng != 9) {
            rhythm_generator(posibilities, _1_meter, body_meters) @=> rhythm;
            rhythm.cap() => leng;
        }

        
        melody_script([12, 11, 9, 7, 9, 5, 2, 7, 0], seed) @=> melody;

        mix_it(melody, rhythm) @=> music;

        
    
    } else if (code == 3) {
        // D
        
    } else if (code == 4) {
        // E
        
    } else if (code == 5) {
        // F
        
        /*
        // - body
        //// rhythm
        "1 /3" => posibilities;
        rhythm_generator(posibilities, _1_meter, body_meters) @=> float rhythm[];
        rhythm.cap() => leng;
        

        //// melody
        "C D Eb F F# G Bb" => payload;
        melody_generator(payload, seed, leng) @=> float melody[];

        
        
        // - tail
        //// rhythm
        "2" => string posibilities;
        rhythm_generator(posibilities, _1_meter, 2) @=> float tail_rhythm[];


        //// melody
        "C D Eb F F# G Bb" => string payload;
        melody_generator(payload, seed, 1) @=> float tail_melody[];
        
        
        
        // - combine music
        mix_it(melody, rhythm) @=> float music[][];
        mix_it(tail_melody, tail_rhythm) @=> float tail_music[][];
        */
        
        
        //// init 
        // rhythm
        "1 /3" => posibilities;
        
        // melody
        "C D Eb F F# G Bb" => payload;
        
        
        // make music
        make_music(posibilities, _1_meter, body_meters, payload, seed) @=> music;
        make_music("2", _1_meter, tail_meters, payload, seed) @=> tail_music;
        
        
        // combine music
        append_music(music, tail_music) @=> music;
        
        
    } else if (code == 6) {
        // G
        
        
        //// init 
        // rhythm
        "/2 /4" => posibilities;
        
        // melody
        "C D F# G" => payload;
        
        // make_music(string r_posibilities, float r_1_meter, float r_total_meters, string m_payload, float m_seed)
        make_music("/2", _1_meter, 0.5, "c", seed) @=> head_music;
        make_music(posibilities, _1_meter, 7.5, payload, seed) @=> music;
        make_music("2", _1_meter, tail_meters, "c", seed+12) @=> tail_music;
        
        
        // combine music
        append_music(head_music, music) @=> music;
        append_music(music, tail_music) @=> music;
        
    } else if (code == 7) {
        // H
        
    } else if (code == 8) {
        // I    
        
        
        //// init 
        // rhythm
        "1 /2 /4" => posibilities;  //  ????????????????????
        
        // melody
        "C D E G A" => payload;
        
        
        // make music
        make_music(posibilities, _1_meter, body_meters, payload, seed) @=> music;
        make_music("2", _1_meter, tail_meters, "c", seed) @=> tail_music;
        
        
        // combine music
        append_music(music, tail_music) @=> music;
        
    } else if (code == 9) {
        // J
        
        
        //// init 
        // rhythm
        "1" => posibilities;  //  ????????????????????
        
        // melody
        "C# E G# C" => string payload_0;
        "D# F# A C" => string payload_1;
        "E G G# D" => string payload_2;
        
        
        // make music
        make_music(posibilities, _1_meter, 4, payload_0, seed) @=> float music_0[][];
        make_music(posibilities, _1_meter, 4, payload_1, seed) @=> float music_1[][];
        make_music(posibilities, _1_meter, 4, payload_2, seed) @=> float music_2[][];
        [music_0, music_1, music_2] @=> float musicx[][][];

        
        random(0, 2) => int a;
        a => int b;
        while (a == b) {
            random(0, 2) => b;
            //<<<a, b>>>;
        }
        
        append_music(musicx[a], musicx[b]) @=> music;
        
        
    } else if (code == 10) {
        // K

        
        "2 /2 /4" => posibilities;
        
        0 => leng;
        float rhythm[];
        float melody[];
        while (leng != 9) {
            rhythm_generator(posibilities, _1_meter, body_meters) @=> rhythm;
            rhythm.cap() => leng;
        }

        
        melody_script([12, 11, 9, 7, 9, 5, 2, 7, 0], seed) @=> melody;

        mix_it(melody, rhythm) @=> music;

    } else if (code == 11) {
        // L
        

        //// init 
        // rhythm
        "1 /2 /4" => posibilities;
        
        // melody
        "D F A D F A F" => payload;
        72 => seed;
        
        // make music
        [just_make_melody(payload, seed, 7), [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]] @=> head_music;
        make_music("1", _1_meter, 1, "f c", seed) @=> music;        
        [melody_generator("d", seed, 1), [0.5]] @=> tail_music;
        
            
        // combine music
        append_music(head_music, music) @=> music;
        append_music(music, tail_music) @=> music;
        
    } else if (code == 12) {
        // M
        
    } else if (code == 13) {
        // N
        
        "C" => payload;
        [melody_script([0, 12, 11, 12], seed), [1.0, 0.5, 1.0, 0.5]] @=> head_music;
        [melody_script([-3, 5, 4, 2, 4, 2], seed), [0.5, 0.25, 0.25, 0.5, 1.0, 0.5]] @=> float _0[][];
        [melody_script([5, 7, 9, 5, 4, 7], seed), [0.6666, 0.3333, 0.5, 0.5, 0.5, 0.5]] @=> float _1[][];
        [melody_script([9, 12, 11, 12, 5, 2], seed), [0.5, 0.25, 0.25, 0.5, 1.0, 0.5]] @=> float _2[][];
        [melody_script([2, 4, 5, 7, 7, 0], seed), [0.25, 0.25, 0.5, 0.6666, 0.3333, 1.0]] @=> float _3[][];
        [_0, _1, _2, _3] @=> float musicx[][][];
        musicx[random(0, 4)] @=> music;
        [[seed], [1.0]] @=> tail_music;
        
        append_music(head_music, music) @=> music;
        append_music(music, tail_music) @=> music;

        
    } else if (code == 14) {
        // O
        
    } else if (code == 15) {
        // P
        
    } else if (code == 16) {
        // Q
        
    } else if (code == 17) {
        // R
        
    } else if (code == 18) {
        // S
        
        
        
        //// init 
        // rhythm
        "/2" => posibilities;  //  ????????????????????
        
        // melody
        "G Bb D F" => payload;
        
        
        // make music
        [melody_script([0, 3], seed), [0.5, 0.5]] @=> head_music;
        make_music(posibilities, _1_meter, 7, payload, seed) @=> music;
        make_music("/3", _1_meter, 1, payload, seed) @=> tail_music;
        
        
        append_music(head_music, music) @=> music;
        append_music(music, tail_music) @=> music;
        
    } else if (code == 19) {
        // T
        
    } else if (code == 20) {
        // U
        
    } else if (code == 21) {
        // V
        
    } else if (code == 22) {
        // W
        
    } else if (code == 23) {
        // X
        
        
        //// init 
        // rhythm
        "1" => posibilities;  //  ????????????????????
        
        // melody
        "C D E G A" => payload;
        
        
        // make music
        make_music(posibilities, _1_meter, body_meters, payload, seed) @=> music;
        make_music("2", _1_meter, tail_meters, "c", seed) @=> tail_music;
        
        
        // combine music
        append_music(music, tail_music) @=> music;
    } else if (code == 24) {
        // Y
        
    } else if (code == 25) {
        // Z    
        
    }
    
    // - play music
    show_time(music);
    
}



// play music
// input your name here
wtf("stanley");















