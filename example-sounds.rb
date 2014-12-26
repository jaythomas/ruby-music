require './lib/synth.rb'

wave = WaveFile.new(1, 44100, 8)

wave.sample_data = SineOscillator.new(44100, 440.0, 0.5).next_samples(44100)
wave.save $0[0..-4] + '-sine-beep.wav'

wave.sample_data = SquareOscillator.new(44100, 440.0, 0.5).next_samples(44100)
wave.save $0[0..-4] + '-square-beep.wav'

wave.sample_data = SawtoothOscillator.new(44100, 440.0, 0.5).next_samples(44100)
wave.save $0[0..-4] + '-sawtooth-beep.wav'

wave.sample_data = NoiseOscillator.new(44100, 440.0, 0.5).next_samples(44100)
wave.save $0[0..-4] + '-noise-beep.wav'

def major_scale
  saw = Instrument.new(120, SineOscillator.new(44100, 220.0, 0.5), [], nil, nil)

  t = Track.new(saw)
  t.notes << Note.new(:a, 4, 4)
  t.notes << Note.new(:b, 4, 4)
  t.notes << Note.new(:cs, 4, 4)
  t.notes << Note.new(:d, 4, 4)
  t.notes << Note.new(:e, 4, 4)
  t.notes << Note.new(:fs, 4, 4)
  t.notes << Note.new(:gs, 4, 4)
  t.notes << Note.new(:a, 5, 4)

  return t.next_samples(t.sample_length)
end

wave.sample_data = major_scale
wave.save $0[0..-4] + '-major-scale.wav'

def minor_scale
  saw = Instrument.new(120, SineOscillator.new(44100, 220.0, 0.5), [], nil, nil)

  t = Track.new(saw)
  t.notes << Note.new(:a, 3, 4)
  t.notes << Note.new(:b, 3, 4)
  t.notes << Note.new(:c, 3, 4)
  t.notes << Note.new(:d, 3, 4)
  t.notes << Note.new(:e, 3, 4)
  t.notes << Note.new(:f, 3, 4)
  t.notes << Note.new(:gs, 3, 4)
  t.notes << Note.new(:a, 4, 4)

  return t.next_samples(t.sample_length)
end

wave.sample_data = minor_scale
wave.save $0[0..-4] + '-minor-scale.wav'

def triads
  bottom = Instrument.new(120, SineOscillator.new(44100, 220.0, 0.5), [], nil, nil)
  middle = Instrument.new(120, SineOscillator.new(44100, 220.0, 0.5), [], nil, nil)
  top = Instrument.new(120, SineOscillator.new(44100, 220.0, 0.5), [], nil, nil)

  bottom_track = Track.new(bottom)
  bottom_track.notes << Note.new(:c, 3, 2)
  bottom_track.notes << Note.new(:c, 3, 2)
  bottom_track.notes << Note.new(:d, 3, 2)
  bottom_track.notes << Note.new(:c, 3, 2)

  middle_track = Track.new(middle)
  middle_track.notes << Note.new(:e, 3, 2)
  middle_track.notes << Note.new(:f, 3, 2)
  middle_track.notes << Note.new(:g, 3, 2)
  middle_track.notes << Note.new(:e, 3, 2)

  top_track = Track.new(top)
  top_track.notes << Note.new(:g, 3, 2)
  top_track.notes << Note.new(:a, 4, 2)
  top_track.notes << Note.new(:b, 4, 2)
  top_track.notes << Note.new(:g, 3, 2)

  s = Song.new()
  s.tracks = [bottom_track, middle_track, top_track]

  return s.next_samples(s.sample_length)
end

wave.sample_data = triads
wave.save $0[0..-4] + '-triads.wav'

def vibrato
  normal = Instrument.new(120, SawtoothOscillator.new(44100, 220.0, 0.3), [], nil, nil)
  vibrato = Instrument.new(120, SawtoothOscillator.new(44100, 220.0, 0.3), [], SineOscillator.new(44100, 9.0, 15.0), nil)

  normal_track = Track.new(normal)
  normal_track.notes << Note.new(:a, 3, 1)

  vibrato_track = Track.new(vibrato)
  vibrato_track.notes << Note.new(:_, 3, 1)
  vibrato_track.notes << Note.new(:a, 3, 1)

  s = Song.new()
  s.tracks = [normal_track, vibrato_track]

  return s.next_samples(s.sample_length)
end

wave.sample_data = vibrato
wave.save $0[0..-4] + '-vibrato.wav'

def tremolo
  normal = Instrument.new(120, SawtoothOscillator.new(44100, 220.0, 0.3), [], nil, nil)
  tremolo = Instrument.new(120, SawtoothOscillator.new(44100, 220.0, 0.3), [], nil, SineOscillator.new(44100, 5.0, 0.3))

  normal_track = Track.new(normal)
  normal_track.notes << Note.new(:a, 3, 1)

  tremolo_track = Track.new(tremolo)
  tremolo_track.notes << Note.new(:_, 3, 1)
  tremolo_track.notes << Note.new(:a, 3, 1)

  s = Song.new()
  s.tracks = [normal_track, tremolo_track]

  return s.next_samples(s.sample_length)
end

wave.sample_data = tremolo
wave.save $0[0..-4] + '-tremolo.wav'

require './lib/19-edo.rb'

def chromatic_scale
  saw = Instrument.new(120, SineOscillator.new(44100, 220.0, 0.5), [], nil, nil)

  t = Track.new(saw)
  t.notes << Note.new(:a, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(0, 4, 16)
  t.notes << Note.new(:as, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(1, 4, 16)
  t.notes << Note.new(:bf, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(2, 4, 16)
  t.notes << Note.new(:b, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(3, 4, 16)
  t.notes << Note.new(:bs, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(4, 4, 16)
  t.notes << Note.new(:c, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(5, 4, 16)
  t.notes << Note.new(:cs, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(6, 4, 16)
  t.notes << Note.new(:df, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(7, 4, 16)
  t.notes << Note.new(:d, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(8, 4, 16)
  t.notes << Note.new(:ds, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(9, 4, 16)
  t.notes << Note.new(:ef, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(10, 4, 16)
  t.notes << Note.new(:e, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(11, 4, 16)
  t.notes << Note.new(:es, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(12, 4, 16)
  t.notes << Note.new(:f, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(13, 4, 16)
  t.notes << Note.new(:fs, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(14, 4, 16)
  t.notes << Note.new(:gf, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(15, 4, 16)
  t.notes << Note.new(:g, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(16, 4, 16)
  t.notes << Note.new(:gs, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(17, 4, 16)
  t.notes << Note.new(:af, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(18, 4, 16)
  t.notes << Note.new(:a, 5, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(19, 4, 16)
  t.notes << Note.new(:a, 4, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(0, 4, 16)
  t.notes << Note.new(:a, 5, 16)
  t.notes << Note.new('', 4, 16)
  t.notes << Note.new(19, 4, 16)

  return t.next_samples(t.sample_length)
end

wave.sample_data = chromatic_scale
wave.save $0[0..-4] + '-19-edo-chromatic-scale.wav'

def chords
  synth = SineOscillator.new(44100, 220.0, 0.5)
  voice1 = Instrument.new(30, synth.dup, [], nil, nil)
  voice2 = Instrument.new(30, synth.dup, [], nil, nil)
  voice3 = Instrument.new(30, synth.dup, [], nil, nil)
  voice4 = Instrument.new(30, synth.dup, [], nil, nil)

  first = Track.new(voice1)
  first.notes << Note.new(:c, 3, 1)

  second = Track.new(voice2)
  second.notes << Note.new(:e, 3, 1)

  third = Track.new(voice3)
  third.notes << Note.new(:g, 3, 1)

  fourth = Track.new(voice4)
  fourth.notes << Note.new(:b, 4, 4)
  fourth.notes << Note.new(:bf, 4, 4)
  fourth.notes << Note.new(:as, 4, 4)
  fourth.notes << Note.new(:c, 4, 4)

  s = Song.new()
  s.tracks = [first, second, third, fourth]

  return s.next_samples(s.sample_length)
end

wave.sample_data = chords
wave.save $0[0..-4] + '-19-edo-chords.wav'
