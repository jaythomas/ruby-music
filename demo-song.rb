require './lib/synth.rb'

bpm = 120
drum_synth = Instrument.new(bpm, NoiseOscillator.new(44100, 220.0, 1.0), [])
bass_synth = Instrument.new(bpm, SquareOscillator.new(44100, 220.0, 0.3), [1.0], nil, nil)
#voice_synth = Instrument.new(bpm, SawtoothOscillator.new(44100, 220.0, 0.3), [], SineOscillator.new(44100, 3.0, 5.0), nil)
#voice_synth = Instrument.new(bpm, SawtoothOscillator.new(44100, 220.0, 0.3), [], nil, SineOscillator.new(44100, 10.0, 0.3))
voice_synth = Instrument.new(bpm, SawtoothOscillator.new(44100, 220.0, 0.3), [], nil, nil)

drums = Track.new drum_synth
2.times do
  7.times do
    drums.notes << Note.new(:_, 0, 4)
    drums.notes << Note.new(:a, 0, 16)
    drums.notes << Note.new(:_, 0, 16)
    drums.notes << Note.new(:_, 0, 8)
  end
  drums.notes << Note.new(:_, 0, 4)
  drums.notes << Note.new(:a, 0, 16)
  drums.notes << Note.new(:_, 0, 16)
  drums.notes << Note.new(:a, 0, 32)
  drums.notes << Note.new(:_, 0, 32)
  drums.notes << Note.new(:a, 0, 16)
end
4.times do
  3.times do
    drums.notes << Note.new(:_, 0, 4)
    drums.notes << Note.new(:a, 0, 16)
    drums.notes << Note.new(:_, 0, 16)
    drums.notes << Note.new(:_, 0, 8)
  end
  drums.notes << Note.new(:_, 0, 4)
  4.times do
    drums.notes << Note.new(:a, 0, 32)
    drums.notes << Note.new(:_, 0, 32)
  end
end


bass = Track.new bass_synth
2.times do
  4.times do
    bass.notes << Note.new(:a, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:d, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:c, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:b, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:a, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:d, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:c, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  3.times do
    bass.notes << Note.new(:e, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
    bass.notes << Note.new(:ef, 1, 16)
    bass.notes << Note.new(:e, 1, 16)
end
2.times do
  4.times do
    bass.notes << Note.new(:a, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:d, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:c, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:b, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:a, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:d, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  2.times do
    bass.notes << Note.new(:c, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  2.times do
    bass.notes << Note.new(:d, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
  4.times do
    bass.notes << Note.new(:a, 1, 16)
    bass.notes << Note.new(:_, 1, 16)
  end
end

voice = Track.new(voice_synth)
2.times do
  voice.notes << Note.new(:a, 3, 4)
  voice.notes << Note.new(:e, 3, 8)
  voice.notes << Note.new(:fs, 3, 4)
  voice.notes << Note.new(:e, 3, 8)
  voice.notes << Note.new(:d, 3, 8)
  voice.notes << Note.new(:e, 3, 4)
  voice.notes << Note.new(:d, 3, 8)
  voice.notes << Note.new(:c, 3, 8)
  voice.notes << Note.new(:e, 3, 2)
  voice.notes << Note.new(:_, 3, 8)

  voice.notes << Note.new(:a, 3, 4)
  voice.notes << Note.new(:e, 3, 8)
  voice.notes << Note.new(:fs, 3, 4)
  voice.notes << Note.new(:e, 3, 8)
  voice.notes << Note.new(:d, 3, 8)
  voice.notes << Note.new(:e, 3, 1)
  voice.notes << Note.new(:_, 3, 8)
end
2.times do
  voice.notes << Note.new(:a, 4, 4)
  voice.notes << Note.new(:fs, 3, 8)
  voice.notes << Note.new(:a, 4, 8)
  voice.notes << Note.new(:b, 4, 8)
  voice.notes << Note.new(:cs, 4, 8)
  voice.notes << Note.new(:b, 4, 8)
  voice.notes << Note.new(:a, 4, 8)
  voice.notes << Note.new(:a, 4, 8)
  voice.notes << Note.new(:a, 4, 8)
  voice.notes << Note.new(:g, 3, 8)
  voice.notes << Note.new(:g, 3, 8)
  voice.notes << Note.new(:e, 3, 2)

  voice.notes << Note.new(:a, 4, 4)
  voice.notes << Note.new(:fs, 3, 8)
  voice.notes << Note.new(:a, 4, 8)
  voice.notes << Note.new(:b, 4, 8)
  voice.notes << Note.new(:cs, 4, 8)
  voice.notes << Note.new(:b, 4, 8)
  voice.notes << Note.new(:a, 4, 8)
  voice.notes << Note.new(:a, 4, 8)
  voice.notes << Note.new(:a, 4, 8)
  voice.notes << Note.new(:g, 3, 8)
  voice.notes << Note.new(:g, 3, 8)
  voice.notes << Note.new(:a, 4, 2)
end


s = Song.new
s.tracks = [drums, bass, voice]

wave = WaveFile.new(1, 44100, 8)
wave.sample_data = s.next_samples(s.sample_length)
wave.save $0[0..-3] + 'wav'
