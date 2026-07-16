package bino.laryssa.backend.exception;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authorization.AuthorizationDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import bino.laryssa.backend.model.dto.ErrorResponse;


@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<ErrorResponse> notFoundException(NotFoundException ex, WebRequest request){
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.NOT_FOUND.value(),
        "Not Found",
        ex.getMessage(),
        request.getDescription(false),
        null
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
        
    }

    @ExceptionHandler({AccessDeniedException.class, AuthorizationDeniedException.class})
    public ResponseEntity<ErrorResponse> accessDenied(Exception ex, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.FORBIDDEN.value(),
        "Forbidden",
        ex.getMessage(),
        request.getDescription(false),
        null
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.FORBIDDEN);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> validException(MethodArgumentNotValidException ex, WebRequest request){
        List<String> errors = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.toList());

        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.BAD_REQUEST.value(),
        "Validation Error",
        "Invalid input data",
        request.getDescription(false),
        errors
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
        
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgument(IllegalArgumentException ex, WebRequest request) {

        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.BAD_REQUEST.value(),
                "Bad Request",
                ex.getMessage(),
                request.getDescription(false),
                null
        );

        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ErrorResponse> authenticationException(AuthenticationException ex, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.UNAUTHORIZED.value(),
            "Unauthorized",
            "Email ou senha inválidos",
            request.getDescription(false),
            null
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(IOException.class)
    public ResponseEntity<ErrorResponse> ioException(IOException ex, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.BAD_GATEWAY.value(),
            "Bad Gateway",
            "Falha ao processar a receita. Tente novamente.",
            request.getDescription(false),
            null
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_GATEWAY);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> global(Exception ex, WebRequest request){
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(),
        "Internal Server Error", 
        ex.getMessage(),
        request.getDescription(false),
        null
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
}