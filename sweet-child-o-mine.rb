require './lib/synth.rb'

bpm = 140
lead_synth = Instrument.new(bpm, SquareOscillator.new(44100, 220.0, 0.2), [], nil, nil)

lead = Track.new(lead_synth)
2.times {
  lead.notes << Note.new(:a, 3, 8)
  lead.notes << Note.new(:a, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
  lead.notes << Note.new(:d, 3, 8)
  lead.notes << Note.new(:d, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
  lead.notes << Note.new(:cs, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
}
2.times {
  lead.notes << Note.new(:b, 3, 8)
  lead.notes << Note.new(:a, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
  lead.notes << Note.new(:d, 3, 8)
  lead.notes << Note.new(:d, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
  lead.notes << Note.new(:cs, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
}
2.times {
  lead.notes << Note.new(:d, 3, 8)
  lead.notes << Note.new(:a, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
  lead.notes << Note.new(:d, 3, 8)
  lead.notes << Note.new(:d, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
  lead.notes << Note.new(:cs, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
}
2.times {
  lead.notes << Note.new(:a, 3, 8)
  lead.notes << Note.new(:a, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
  lead.notes << Note.new(:d, 3, 8)
  lead.notes << Note.new(:d, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
  lead.notes << Note.new(:cs, 4, 8)
  lead.notes << Note.new(:e, 3, 8)
}
lead.notes << Note.new(:a, 3, 2)


s = Song.new
s.tracks = [lead]

wave = WaveFile.new(1, 44100, 8)
wave.sample_data = s.next_samples(s.sample_length)
wave.save $0[0..-3] + 'wav'
