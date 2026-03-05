package tn.esprit.studentmanagement.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tn.esprit.studentmanagement.entities.Department;
import tn.esprit.studentmanagement.repositories.DepartmentRepository;

import java.util.List;

@Service
public class DepartmentService implements IDepartmentService {

    @Autowired
    DepartmentRepository departmentRepository;

    @Override
    public List<Department> getAllDepartments() {
        return departmentRepository.findAll();
    }

    @Override
    public Department getDepartmentById(Long idDepartment) {
        // FIXED: use orElseThrow() instead of get()
        // If department not found, throws a clear exception instead of crashing silently
        return departmentRepository.findById(idDepartment)
                .orElseThrow(() -> new RuntimeException("Department not found with id: " + idDepartment));
    }

    @Override
    public Department saveDepartment(Department department) {
        return departmentRepository.save(department);
    }

    @Override
    public void deleteDepartment(Long idDepartment) {
        departmentRepository.deleteById(idDepartment);
    }
}