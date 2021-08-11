package cornerContourGluonTest;

import gluon.webgl.GLContext;
import gluon.webgl.GLProgram;
import gluon.webgl.GLBuffer;

import typedarray.Float32Array;
import typedarray.Uint16Array;
//import haxe.io.Float32Array;


inline
function bufferSetup( gl:           GLContext
                    , program:      GLProgram
                    , data:         Float32Array
                    , ?isDynamic:    Bool = false ): GLBuffer {
    var buf: GLBuffer = gl.createBuffer();
    gl.bindBuffer( ARRAY_BUFFER, buf );
    if( isDynamic ){
        gl.bufferData( ARRAY_BUFFER, data, DYNAMIC_DRAW );
    } else {
        gl.bufferData( ARRAY_BUFFER, data, STATIC_DRAW );
    }
    return buf;	
}
/*
// change to DYNAMIC_DRAW
inline 
function passIndicesToShader( gl: GLContext, indices: Array<Int>, ?isDynamic: Bool = false ): Buffer {
        var buf: Buffer = gl.createBuffer(); // triangle indicies data 
        gl.bindBuffer( ARRAY_BUFFER, buf );
        if( isDynamic ){ 
            gl.bufferData( ELEMENT_ARRAY_BUFFER
                         , cast new Uint16Array( indices )
                         , DYNAMIC_DRAW );
        } else {
            gl.bufferData( ELEMENT_ARRAY_BUFFER
                         , cast new Uint16Array( indices )
                         , STATIC_DRAW );
        }
        gl.bindBuffer( ARRAY_BUFFER, null );
        return buf;
}
*/
inline
function dataSet( gl: GLContext, data: Float32Array, isDraw: Int ){
    gl.bufferData( ARRAY_BUFFER, data, isDraw );
}

inline
function inputAttribute( gl: GLContext, program: GLProgram, name: String ): Int {
    return gl.getAttribLocation( program, name );
}

inline
function inputAttEnable(  gl: GLContext, program: GLProgram, name: String
                        , size: Int, stride: Int, off: Int ){
    var inp            = inputAttribute( gl, program, name );
    var elementBytes   = Float32Array.BYTES_PER_ELEMENT;
    var fp             = FLOAT;
    var strideBytes    = Std.int( stride*elementBytes );
    var offBytes       = Std.int( off*elementBytes );
    gl.vertexAttribPointer( inp, size, fp, false, strideBytes, offBytes );
    gl.enableVertexAttribArray( inp );
    return inp;
}
inline
function interleaveXY_RGBA( gl:             GLContext
                           , program:       GLProgram 
                           , data:          Float32Array
                           , xyName:        String
                           , rgbaName:      String
                           , ?isDynamic:    Bool = false ): GLBuffer {
    var vbo          = bufferSetup( gl, program, data, isDynamic ); 
    // X Y   R G B A
    inputAttEnable( gl, program, xyName, 2, 6, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 6, 2 );
    return vbo;
}
inline
function updateBufferXY_RGBA( gl:       GLContext
                           , program:     GLProgram 
                           , xyzName:     String
                           , rgbaName:    String ){
    inputAttEnable( gl,  program, xyzName, 2, 6, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 6, 2 );
}

// just used for docs
class BufferGL{
    public var bufferSetup_: ( gl: GLContext
                             , program: GLProgram
                             , data: Float32Array
                             , ?isDynamic: Bool ) -> GLBuffer = bufferSetup;
                             /*
    public var passIndicesToShader_: ( gl:           GL
                                     , indices:   Array<Int>
                                     , ?isDynamic: Bool ) -> Buffer = passIndicesToShader;
                             */
    public var interleaveXY_RGBA_: ( gl:       GLContext
                                    , program:   GLProgram 
                                    , data:      Float32Array
                                    , inPosName: String
                                    , inColName: String
                                    , ?isDynamic: Bool )->GLBuffer = interleaveXY_RGBA;   
}