# code: utf-8

class MusicTheory

  StandardNoteRatios =
  {
    # Perfect unison (P1)
    '0'    => 1.0,
    'a'    => 1.0,
    'gss'  => 1.0,
    'bff'  => 1.0,

    # Minor second (m2)
    '1'    => 2**(1.0/12),
    'as'   => 2**(1.0/12),
    'bf'   => 2**(1.0/12),
    'cff'  => 2**(1.0/12),

    # Major second (M2)
    '2'    => 2**(2.0/12),
    'b'    => 2**(2.0/12),
    'ass'  => 2**(2.0/12),
    'cff'  => 2**(2.0/12),

    # Minor third (m3)
    '3'    => 2**(3.0/12),
    'c'    => 2**(3.0/12),
    'bs'   => 2**(3.0/12),
    'dff'  => 2**(3.0/12),

    # Major third (M3)
    '4'    => 2**(4.0/12),
    'cs'   => 2**(4.0/12),
    'bff'  => 2**(4.0/12),
    'df'   => 2**(4.0/12),

    # Perfect fourth (P4)
    '5'    => 2**(5.0/12),
    'd'    => 2**(5.0/12),
    'css'  => 2**(5.0/12),
    'eff'  => 2**(5.0/12),

    # Augmented fourth / Diminished fifth (d4)
    '6'    => 2**(6.0/12),
    'ds'   => 2**(6.0/12),
    'ef'   => 2**(6.0/12),
    'fff'  => 2**(6.0/12),

    # Perfect fifth (P5)
    '7'    => 2**(7.0/12),
    'e'    => 2**(7.0/12),
    'dss'  => 2**(7.0/12),
    'ff'   => 2**(7.0/12),

    # Augmented fifth (A5) / Minor sixth (m6)
    '8'    => 2**(8.0/12),
    'f'    => 2**(8.0/12),
    'es'   => 2**(8.0/12),
    'gff'  => 2**(8.0/12),

    # Major sixth (M6)
    '9'    => 2**(9.0/12),
    'fs'   => 2**(9.0/12),
    'ess'  => 2**(9.0/12),
    'gf'   => 2**(9.0/12),

    # Minor seventh (m7)
    '10'   => 2**(10.0/12),
    'g'    => 2**(10.0/12),
    'fss'  => 2**(10.0/12),
    'aff'  => 2**(10.0/12),

    # Major seventh (M7)
    '11'   => 2**(11.0/12),
    'gs'   => 2**(11.0/12),
    'af'   => 2**(11.0/12),

    # Perfect Octave (P8)
    '12'   => 2.0
  }

end


class Oscillator

  attr_accessor :amplitude
  attr_reader :sample_rate, :period_offset, :period_delta

  def initialize(sample_rate, frequency, amplitude)
    @sample_rate = sample_rate
    self.frequency = frequency
    @amplitude = amplitude

    @period_offset = 0.0
  end

  def next_sample
    sample = wave_function

    @period_offset += @period_delta
    if @period_offset >= 1.0
      @period_offset -= 1.0
    end

    return sample
  end

  def next_samples(num_samples)
    samples = Array.new(num_samples)

    (0..num_samples).each do |i|
      samples[i - 1] = next_sample
    end

    return samples
  end

  def frequency
    @frequency
  end

  def frequency=(new_frequency)
    @frequency = new_frequency
    @period_delta = @frequency / @sample_rate
  end

end


class SineOscillator < Oscillator
  def wave_function
    @amplitude * Math::sin(@period_offset * 2.0 * Math::PI)
  end
end


class SquareOscillator < Oscillator
  def wave_function
    if @period_offset >= 0.5
      return @amplitude
    else
      return -@amplitude
    end
  end
end


class SawtoothOscillator < Oscillator
  def wave_function
    (1.0 - (@period_offset * 2.0)) / (1.0 / @amplitude)
  end
end


class NoiseOscillator < Oscillator
  def wave_function
    if @frequency == 0.0
      return 0.0
    else
      return (1.0 - (rand() * 2.0)) / (1.0 / @amplitude)
    end
  end
end


class Instrument

  attr_reader :tempo, :bpm, :overtones, :note, :note_sample_length, :samples_per_beat

  def initialize(bpm, oscillator, overtones, vibrato_lfo = nil, volume_lfo = nil)
    @bpm = bpm
    @oscillator = oscillator
    @overtones = overtones
    @vibrato_lfo = vibrato_lfo
    @volume_lfo = volume_lfo

    @prev_vibrato_sample = 0.0
    @prev_volume_sample = 0.0

    @samples_per_beat = (oscillator.sample_rate * 60) / bpm;
    @note = nil
    @note_sample_length = 0
    @sampleIndex = 0

    @overtone_oscillators = Array.new(@overtones.length)
    i = 0
    while i < @overtones.length do
      @overtone_oscillators[i] = @oscillator.clone
      @overtone_oscillators[i].frequency = @oscillator.frequency * (i + 2)
      @overtone_oscillators[i].amplitude = @overtones[i]
      i += 1
    end
  end


  def update_frequencies
    current_vibrato_sample = @vibrato_lfo.next_sample()
    vibrato_delta = current_vibrato_sample - @prev_vibrato_sample
    @prev_vibrato_sample = current_vibrato_sample

    # Adjust frequency of the oscillators by the vibrato delta
    @oscillator.frequency += vibrato_delta
    (0..@overtones.length - 1).each do |i|
      @overtone_oscillators[i].frequency = @oscillator.frequency * (i + 2)
    end
  end

  def update_amplitudes
    current_volume_sample = @volume_lfo.next_sample()
    volumeDelta = current_volume_sample - @prev_volume_sample
    @prev_volume_sample = current_volume_sample

    @oscillator.amplitude += volumeDelta
    if @oscillator.amplitude > 1.0
      @oscillator.amplitude = 1.0
    end

    @overtone_oscillators.each do |o|
      o.amplitude += volumeDelta
      if o.amplitude > 1.0
        o.amplitude = 1.0
      end
    end
  end


  def next_sample
    sample = 0.0

    if @note != nil && @sampleIndex < @note_sample_length

      if @vibrato_lfo != nil
        update_frequencies()
      end

      if @volume_lfo != nil
        update_amplitudes()
      end

      sample = @oscillator.next_sample()

      @overtone_oscillators.each do |o|
        sample += o.next_sample()
      end
      sample = sample / (@overtones.length + 1)

      @sampleIndex += 1

      if(@sampleIndex >= @note_sample_length)
        @note = nil
      end
    end

    sample
  end

  def next_samples(num_samples)
    samples = Array.new(num_samples)

    (0..num_samples).each do |i|
      samples[i - 1] = next_sample()
    end

    samples
  end


  def note=(newNote)
    if(newNote != nil)
      @note = newNote
      @oscillator.frequency = newNote.frequency

      (0..@overtone_oscillators.length - 1).each do |i|
        @overtone_oscillators[i].frequency = newNote.frequency * (i + 2)
      end

      @sampleIndex = 0
      @note_sample_length = @samples_per_beat * (4.0 / newNote.duration)
    end
  end

end


class Song

  attr_accessor :tracks

  def initialize
    @tracks = []
  end

  def next_sample
    sample = @tracks.inject(0.0) {|sum, track| sum += track.next_sample() }
    sample = sample / @tracks.length
  end

  def next_samples(num_samples)
    samples = Array.new(num_samples)

    (0..num_samples).each do |i|
      samples[i - 1] = next_sample()
    end

    samples
  end

  def sample_length()
    @tracks.inject(0) {|longest, track| (longest > track.sample_length) ? longest : track.sample_length}
  end

end


class Track

  attr_accessor :notes, :instrument

  def initialize(instrument)
    @instrument = instrument
    @notes = []
    @noteIndex = -1
    @sample_length = 0
  end

  def next_sample
    if @noteIndex == -1
        @instrument.note = @notes[0]
        @noteIndex = 0
    end

    if @instrument.note != nil
      sample = @instrument.next_sample
    else
      if @noteIndex < @notes.length
        @noteIndex += 1

        @instrument.note = @notes[@noteIndex]
        sample = @instrument.next_sample()
      else
        sample = 0.0
      end
    end

    sample
  end


  def next_samples(num_samples)
    samples = Array.new(num_samples)

    (0..num_samples).each do |i|
      samples[i - 1] = next_sample()
    end

    samples
  end

  def sample_length()
    @notes.inject(0) {|sum, note| sum + (@instrument.samples_per_beat * (4.0 / note.duration)) }
  end

end


class Note

  attr_reader :note_name, :octave, :duration, :frequency

  MiddleFrequency = 440.0
  MiddleOctave = 4.0

  def initialize(note_name, octave, duration)
    @note_name = note_name.to_s.downcase
    @octave = octave
    @duration = duration

    if @note_name.empty? or @note_name == '_'
      @frequency = 0.0
    else
      octave_multiplier = 2.0 ** (octave - MiddleOctave)
      @note_name.gsub! '#', 's'
      @note_name.gsub! '♯', 's'
      @note_name.gsub! '𝄪', 'ss'
      @note_name.gsub! '♭', 'f'
      @note_name.gsub! '𝄫', 'ff'
      note_ratio = if defined? MusicTheory::NoteRatios
        MusicTheory::NoteRatios[@note_name] * octave_multiplier
      else
        MusicTheory::StandardNoteRatios[@note_name] * octave_multiplier
      end
      @frequency = note_ratio * MiddleFrequency
    end
  end

end


class Rest

  attr_reader :duration

  def initialize(duration)
    @duration = duration
  end

end

=begin
WAV File Specification
FROM http://ccrma.stanford.edu/courses/422/projects/WaveFormat/
The canonical WAVE format starts with the RIFF header:
0         4   ChunkID          Contains the letters "RIFF" in ASCII form
                               (0x52494646 big-endian form).
4         4   ChunkSize        36 + SubChunk2Size, or more precisely:
                               4 + (8 + SubChunk1Size) + (8 + SubChunk2Size)
                               This is the size of the rest of the chunk
                               following this number.  This is the size of the
                               entire file in bytes minus 8 bytes for the
                               two fields not included in this count:
                               ChunkID and ChunkSize.
8         4   Format           Contains the letters "WAVE"
                               (0x57415645 big-endian form).

The "WAVE" format consists of two subchunks: "fmt " and "data":
The "fmt " subchunk describes the sound data's format:
12        4   Subchunk1ID      Contains the letters "fmt "
                               (0x666d7420 big-endian form).
16        4   Subchunk1Size    16 for PCM.  This is the size of the
                               rest of the Subchunk which follows this number.
20        2   AudioFormat      PCM = 1 (i.e. Linear quantization)
                               Values other than 1 indicate some
                               form of compression.
22        2   NumChannels      Mono = 1, Stereo = 2, etc.
24        4   SampleRate       8000, 44100, etc.
28        4   ByteRate         == SampleRate * NumChannels * BitsPerSample/8
32        2   BlockAlign       == NumChannels * BitsPerSample/8
                               The number of bytes for one sample including
                               all channels. I wonder what happens when
                               this number isn't an integer?
34        2   BitsPerSample    8 bits = 8, 16 bits = 16, etc.

The "data" subchunk contains the size of the data and the actual sound:
36        4   Subchunk2ID      Contains the letters "data"
                               (0x64617461 big-endian form).
40        4   Subchunk2Size    == NumSamples * NumChannels * BitsPerSample/8
                               This is the number of bytes in the data.
                               You can also think of this as the size
                               of the read of the subchunk following this
                               number.
44        *   Data             The actual sound data.
=end

class WaveFile

  attr_reader :num_channels, :sample_rate, :bits_per_sample, :byte_rate, :block_align,
              :init_time
  attr_writer :sample_data

  HeaderSize = 36

  def initialize(num_channels, sample_rate, bits_per_sample, verbose=true)
    @init_time = Time.now if verbose
    @num_channels = num_channels
    @sample_rate = sample_rate
    @bits_per_sample = bits_per_sample

    @byte_rate = sample_rate * num_channels * (bits_per_sample / 8)
    @block_align = num_channels * (bits_per_sample / 8)
    @sample_data = []
    @chunkSize = HeaderSize + 0 # Header size + x
  end

  def save(path)
    puts "\e[96mSaving to file \"\e[93m#{path}\e[96m\"...\e[0m" if init_time
    # All numeric values should be saved in little-endian format
    sample_data_size = @sample_data.length * @num_channels * (@bits_per_sample / 8)

    file_contents = 'RIFF' # Chunk ID
    file_contents += [HeaderSize + sample_data_size].pack('V')
    file_contents += 'WAVE' # Format
    file_contents += 'fmt '  # Sub-chunk 1 ID
    file_contents += [16].pack('V') # Sub-chunk 1 size
    file_contents += [1].pack('v')  # Audio format
    file_contents += [@num_channels].pack('v')
    file_contents += [@sample_rate].pack('V')
    file_contents += [@byte_rate].pack('V')
    file_contents += [@block_align].pack('v')
    file_contents += [@bits_per_sample].pack('v')
    file_contents += 'data' # Sub-chunk 2 ID
    file_contents += [sample_data_size].pack('V')
    if @bits_per_sample == 8
      # Samples in 8-bit wave files are stored as a unsigned byte
      # Effective values are 0 to 255
      @sample_data = @sample_data.map {|sample| ((sample * 127.0).to_i) + 127 }
      file_contents += @sample_data.pack('C*')
    elsif @bits_per_sample == 16
      # Samples in 16-bit wave files are stored as a signed little-endian short
      # Effective values are -32768 to 32767
      @sample_data = @sample_data.map {|sample| (sample * 32767.0).to_i }
      file_contents += @sample_data.pack('v*')
    else
      puts "\e[91mSomething bad happened.\e[0m"
    end

    aFile = File.open(path, 'w')
    aFile.syswrite(file_contents)
    aFile.close
    if init_time
      stop_time = Time.now
      puts "\e[96mWave file written after \e[93m#{stop_time-init_time}\e[96m seconds.\e[0m"
    end
    @sample_data
  end

end

