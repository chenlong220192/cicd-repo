package site.mingsha.cicd.facade.dto;


/**
 * @author chenlong
 * @date 2020-06-09
 */
public class TemplateRequestDTO {

    private Long id;

    /**
     *
     * @return
     */
    public static TemplateRequestDTO newInstance() {
        return new TemplateRequestDTO();
    }

    public Long getId() {
        return id;
    }

    public TemplateRequestDTO setId(Long id) {
        this.id = id;
        return this;
    }
}
