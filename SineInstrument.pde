// to make an Instrument we must define a class
// that implements the Instrument interface.
class SineInstrument implements Instrument
{
  Oscil wave;
  Line  ampEnv;
  Flanger effect;
  
  SineInstrument( float frequency )
  {
    // make a sine wave oscillator
    // the amplitude is zero because 
    // we are going to patch a Line to it anyway
    wave   = new Oscil( frequency, 1, Waves.TRIANGLE );
    ampEnv = new Line();
    effect = new Flanger(cloud, // delay length in milliseconds ( clamped to [0,100] )
                         0.2,   // lfo rate in Hz ( clamped at low end to 0.001 )
                         1,  // delay depth in milliseconds ( minimum of 0 ); map the degree to 0-1 sec
                         abs(p-1013.25)*0.01,   // amount of feedback ( clamped to [0,1] );difference between current pressure and stardard pressure
                         1,   // amount of dry signal ( clamped to [0,1] )
                         0    // amount of wet signal ( clamped to [0,1] )
                         );
    
    //patch them all together for output
    ampEnv.patch( wave.amplitude );
  }
  
  // this is called by the sequencer when this instrument
  // should start making sound. the duration is expressed in seconds.
  void noteOn( float duration )
  {
    // start the amplitude envelope
    ampEnv.activate( duration, 0.1f, 0 );
    // attach the oscil to the output so it makes sound
    wave.patch( effect ).patch( out );
  }
  
  // this is called by the sequencer when the instrument should
  // stop making sound
  void noteOff()
  {
    wave.unpatch( out );
  }
}
