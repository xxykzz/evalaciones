//SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

//CREAREMOS UN SISTEMA DE NOTAS UNIVERSITARIAS

//alumnos
// Oda | 77755N | 5
// Thor | 12345X | 9
// Bella | 02468T | 2
// Ron | 13579U | 3


contract notas {
    
    //Direccion del profesor
    address public profesor;
    
    //constructor, construye en primer lugar las variables iniciales del smart contract
    constructor() public {
        profesor = msg.sender;
    }
    
    //Mapping para relacionar el hash de la identidad del alumno con su nota del examen
    mapping(bytes32 => uint) Notas;
    
    
    //array de alumnos que soliciten revision de examen
    string[] revisiones;
    
    // eventos
    event alumno_evaluado(bytes32, uint);
    event evento_revision(string);
    
    //Funciones
    
    //Funcion para evaluar alumnos
    //parametros de entrada, id alumno => stringn nota uint
    //solo el que deployo el contrato (profesor) podra ejecutr la fx evaluar
    function evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender) {
        //hash de la identificcion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        // relacion entre el hash del ID del alumn y su Notas
        Notas[hash_idAlumno] = _nota;
        //Emision del evento_revision
        emit alumno_evaluado(hash_idAlumno, _nota);
    }
    
    //Modificador, controla que la funcion de evaluar solo la pueda controlar el profesor
    modifier UnicamenteProfesor(address _direccion) {
        // requiere que la direccion introucida por parametro sea = al owner del contrato
        require(_direccion == profesor, "No tienes permisos para ejecutar esta funcion");
        _;
    }
    
    //funcion para ver las notas de un alumno de clase
    
    function verNotas(string memory _idAlumno) public view returns(uint) {
        //hash de la identificcion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //devolvemos la nota asociada al hash del alumno
        uint nota_alumno = Notas[hash_idAlumno];
        //visualizar la nota del alumno
        return nota_alumno;
    }
    
    
    // funcion para solicitar una revision de la nota_alumno
    function revision(string memory _idAlumno) public {
        // almaceniamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);
        //emision del evento_revision
        emit evento_revision(_idAlumno);
    } 
    
    //funcion para ver los alumnos que han solicitadi revision de examen
    //con el modifier UnicamenteProfesor se limita quien puede llamar a este metodo
    function verRevisiones() public view UnicamenteProfesor(msg.sender) returns(string [] memory){
        //devolver las identidades de los alumnos
        return revisiones;
    }
    
    
}