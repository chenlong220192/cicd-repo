package site.mingsha.cicd.facade.dto;

/**
 * @author chenlong
 * @date 2020-06-09
 */
public class TemplateResponseDTO {

    private Long id;

    /**
     *
     * @return
     */
    public static TemplateResponseDTO newInstance() {
        return new TemplateResponseDTO();
    }

    public Long getId() {
        return id;
    }

    public TemplateResponseDTO setId(Long id) {
        this.id = id;
        return this;
    }
}
